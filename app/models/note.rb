class Note < ApplicationRecord
  include Constrainable
  include Linkable
  include Pageable
  include Remarkable

  MAX_TITLE = 50

  belongs_to :user, inverse_of: :notes

  before_validation :normalize_attributes

  validates :markdown, presence: true
  validates :title, presence: true, length: { maximum: MAX_TITLE }

  default_scope { order(created_at: :desc) }

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
