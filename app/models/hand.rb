class Hand
  attr_reader :error

  CARD = {
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "J" => 11,
    "T" => 10,
    "9" => 9,
    "8" => 8,
    "7" => 7,
    "6" => 6,
    "5" => 5,
    "4" => 4,
    "3" => 3,
    "2" => 2,
  }

  SHAPE = /\A\d{4,5}\z/

  EXAMPLES = [
    "84|KQJT9543|8|85",
    "632|8543|973|754",
    "|763|KJT853|AQ92",
    "AQT9854|JT94||53",
    "QJT53|32|Q9|Q652",
    "AK863|65|73|Q864",
  ]

  def initialize(input)
    parse(input.to_s.upcase.gsub(/\s+/, ""))
  end

  def error? = !!@error

  def to_s
    @cards.map{ |suit| suit.join("") }.join("|")
  end

  def hand
    {
      "S" => spades,
      "H" => hearts,
      "D" => diamonds,
      "C" => clubs,
    }
  end

  def spades
    @cards[0]
  end

  def hearts
    @cards[1]
  end

  def diamonds
    @cards[2]
  end

  def clubs
    @cards[3]
  end

  def shape
    @cards.map(&:length).sort.reverse.join("")
  end

  def points
    @cards.flatten.map do |card|
      case card
      when "A" then 4
      when "K" then 3
      when "Q" then 2
      when "J" then 1
      else          0
      end
    end.sum
  end

  private

  def parse(str)
    @cards = []
    prev = nil
    str.gsub!(/10/, "T")
    str.each_char do |c|
      if CARD.has_key?(c)
        @cards.push(Array.new) if prev.nil? || prev <= CARD[c]
        @cards.last.push(c)
        prev = CARD[c]
      else
        @cards.push(Array.new) if prev.nil?
        prev = nil
      end
    end
    while @cards.length < 4 do
      @cards.push(Array.new)
    end
    if @cards.length > 4
      @error = I18n.t("hand.errors.suits")
    else
      total = @cards.map(&:length).sum
      @error = I18n.t("hand.errors.over") if total > 13
      @error = I18n.t("hand.errors.under") if total < 13
    end
  end
end
