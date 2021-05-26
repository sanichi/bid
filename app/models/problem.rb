class Problem < ApplicationRecord
  include Constrainable
  include Linkable
  include Pageable
  include Remarkable

  CAT_FORMAT = /\A[\w\d &‘-]+\z/
  MAX_CATEGORY = 50
  MAX_HAND = 16
  VULS = %w/na both non none vul/

  belongs_to :user

  before_validation :normalize_attributes

  validates :category, presence: true, length: { maximum: MAX_CATEGORY }, format: { with: CAT_FORMAT }
  validates :note, presence: true
  validates :vul, inclusion: { in: VULS }

  validate :check_hand
  validate :check_bids

  def self.search(matches, params, path, opt={})
    matches = matches.includes(:user)
    if sql = cross_constraint(params[:query], %w{note})
      matches = matches.where(sql)
    end
    if params[:shape].present? && params[:shape].match?(Hand::SHAPE)
      matches = matches.where(shape: params[:shape])
    end
    if (min = params[:min].to_i) > 0
      matches = matches.where("points >= ?", min)
    end
    if (max = params[:max].to_i) > 0
      matches = matches.where("points <= ?", max)
    end
    if params[:category]&.match(CAT_FORMAT)
      matches = matches.where(category: params[:category])
    end
    if (user_id = params[:user_id].to_i) > 0
      matches = matches.where(user_id: user_id)
    end
    case params[:order]
    when "shape"
      matches = matches.order(shape: :asc, points: :desc)
    when "category"
      matches = matches.order(category: :asc, points: :desc)
    else
      matches = matches.order(points: :desc, shape: :asc)
    end
    paginate(matches, params, path, opt)
  end

  def html
    to_html(link_notes(note))
  end

  private

  def normalize_attributes
    category&.squish!
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
      self.shape = h.shape
      self.points = h.points
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
