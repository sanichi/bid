class Note < ApplicationRecord
  include Constrainable
  include Linkable
  include Pageable
  include Remarkable

  TITLE_MAX = 50
  TITLE_FORMAT = /\A[\w\d &-‘]+\z/

  belongs_to :user, inverse_of: :notes

  before_validation :normalize_attributes

  validates :markdown, presence: true
  validates :title, presence: true, length: { maximum: TITLE_MAX }, format: { with: TITLE_FORMAT }

  default_scope            { order(created_at: :desc) }
  scope :targets, ->(text) { where("title ILIKE ?", "%#{text}%") }

  def self.search(matches, params, path, opt={})
    matches = matches.includes(:user)
    if sql = cross_constraint(params[:query], %w{title markdown})
      matches = matches.where(sql)
    end
    if (user_id = params[:user_id].to_i) > 0
      matches = matches.where(user_id: user_id)
    end
    paginate(matches, params, path, opt)
  end

  def html
    to_html(link_notes(markdown))
  end

  private

  def normalize_attributes
    title&.squish!
    self.markdown = clean(markdown)
  end

  def clean(text)
    return nil if markdown.blank?
    text.strip.gsub(/\r\n/, "\n").gsub(/([^\S\n]*\n){2,}[^\S\n]*/, "\n\n")
  end
end
