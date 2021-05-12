class Bids
  attr_reader :error

  PASS = /P(?:ASS)?/
  BID = /[1-7](?:C|D|H|S|NT?)/
  DBL = /DBL?|X(?!X)/
  RDB = /RDB?L?|XX/
  SEP = /[| ]+/

  EXAMPLES = [
    "P|P|1H",
    "P|P|P|1C|P|1S",
    "P|3D|X",
    "1N|X|XX",
    "P|1S|P|3S|P|4C|P|4D|P|4N|P|5H|P|6S",
    "1N|P|3N",
    "1N|P|2C|P|2S|P|3S|P|4S",
    "1N|X",
    "1N|X|XX",
    "1N|X|2C|X",
  ]

  def initialize(input)
    parse(input.to_s.upcase.gsub(/\s+/, " "))
  end

  def error? = !!@error

  def to_s
    @bids.join("|")
  end

  private

  def parse(str)
    @bids = []
    index = 0
    current_level = 1.0
    last_bid = nil
    last_bid_index = nil
    last_double_index = nil
    doubled = false
    redoubled = false
    number_of_passes = 0
    s = StringScanner.new(str)
    begin
      while !s.eos?
        if s.scan(PASS)
          raise I18n.t("bids.errors.pass") if number_of_passes >= 3
          @bids.push("P")
          number_of_passes += 1
          index += 1
        elsif s.scan(BID)
          bid = s.matched.sub("NT", "N")
          raise I18n.t("bids.errors.level") unless last_bid.nil? || level(bid) > level(last_bid)
          @bids.push(bid)
          last_bid, last_bid_index = bid, index
          doubled, redoubled, last_double_index = false, false, nil
          number_of_passes = 0
          index += 1
        elsif s.scan(DBL)
          raise I18n.t("bids.errors.double") unless opponent?(last_bid_index, index) && !doubled && !redoubled
          @bids.push("X")
          doubled, last_double_index = true, index
          number_of_passes = 0
          index += 1
        elsif s.scan(RDB)
          raise I18n.t("bids.errors.redouble") unless opponent?(last_double_index, index) && !redoubled
          @bids.push("XX")
          redoubled = true
          number_of_passes = 0
          index += 1
        elsif s.scan(SEP)
          # nothing to do here, scanner will automatically skip separators
        else
          raise I18n.t("bids.errors.char")
        end
      end
      raise I18n.t("bids.errors.none") if @bids.empty?
    rescue => e
      @error = e.message
    end
  end

  def level(bid)
    case bid[-1]
    when "C" then 0.1
    when "D" then 0.2
    when "H" then 0.3
    when "S" then 0.4
    else          0.5
    end + bid.to_f
  end

  def opponent?(last_index, current_index)
    return false if last_index.nil?
    (last_index - current_index).odd?
  end

  def pass?(str) = str.match?(PASS)
  def bid?(str) = str.match?(BID)
  def dbl?(str) = str.match?(/\A#{DBL}\z/)
  def rdb?(str) = str.match?(RDB)
end
