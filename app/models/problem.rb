class Problem < ApplicationRecord
  include Constrainable
  include Linkable
  include Pageable
  include Remarkable

  CAT_FORMAT = /\A[\w\d &‘-]+\z/
  MAX_CATEGORY = 50
  VULS = %w/na both non none vul/

  belongs_to :user
  has_many :reviews

  before_validation :normalize_attributes

  validates :category, presence: true, length: { maximum: MAX_CATEGORY }, format: { with: CAT_FORMAT }
  validates :note, presence: true
  validates :vul, inclusion: { in: VULS }

  validate :check_hand
  validate :check_bids

  def self.search(matches, params, path, opt={})
    matches = shape_min_max_cat(matches, params)
    if sql = cross_constraint(params[:query], %w{note})
      matches = matches.where(sql)
    end
    case params[:order]
    when "shape"
      matches = matches.order(shape: :asc, points: :desc)
    when "category"
      matches = matches.order(category: :asc, points: :desc)
    when "points"
      matches = matches.order(points: :desc, shape: :asc)
    else
      matches = matches.order(created_at: :desc)
    end
    paginate(matches, params, path, opt)
  end

  def self.select(matches, params, path, opt={})
    matches = shape_min_max_cat(matches, params)
    if params[:type] == "new"
      pids = Review.where(user_id: params[:user_id]).pluck(:problem_id)
      matches = matches.where.not(id: pids).order(:id)
    else
      matches = matches.joins(:reviews).where("reviews.user_id = ?", params[:user_id])
      case params[:type]
      when "day"
        matches = matches.where("reviews.due > ?", Time.now).where("reviews.due <= ?", Time.now + 1.day)
      when "days"
        matches = matches.where("reviews.due > ?", Time.now).where("reviews.due <= ?", Time.now + 3.day)
      when "week"
        matches = matches.where("reviews.due > ?", Time.now).where("reviews.due <= ?", Time.now + 7.day)
      else
        matches = matches.where("reviews.due <= ?", Time.now)
      end
    end
    paginate(matches, params, path, opt)
  end

  def html(modal: false)
    to_html(link_notes(note, modal: modal))
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

  def self.shape_min_max_cat(matches, params)
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
    matches
  end
end
