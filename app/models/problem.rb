class Problem < ApplicationRecord
  include Constrainable
  include Pageable
  include Remarkable

  MAX_HAND = 16
  VULS = %w/na both non vul/

  belongs_to :user

  before_validation :normalize_attributes

  validates :vul, inclusion: { in: VULS }
  validates :note, presence: true

  validate :check_hand
  validate :check_bids

  def self.search(matches, params, path, opt={})
    matches = matches.includes(:user)
    if sql = cross_constraint(params[:query], %w{note})
      matches = matches.where(sql)
    end
    if (user_id = params[:user_id].to_i) > 0
      matches = matches.where(user_id: user_id)
    end
    paginate(matches, params, path, opt)
  end

  def html
    to_html(note)
  end

  private

  def normalize_attributes
    bids&.squish!
    hand&.squish!
    if note.present?
      self.note = note.strip.gsub(/\r\n/, "\n").gsub(/([^\S\n]*\n){2,}[^\S\n]*/, "\n\n")
    end
  end

  def check_hand
    h = Hand.new(hand)
    if h.error?
      errors.add(:hand, h.error)
    else
      self.hand = h.to_s
    end
  end

  def check_bids
    b = Bids.new(bids)
    if b.error?
      errors.add(:bids, b.error)
    else
      self.bids = b.to_s
    end
  end
end
