module Linkable
  extend ActiveSupport::Concern

  LINK = /
    \{
      (?:([^}|]+)\|)?
      ([^}|]+)
    \}
  /x

  included do
    def link_notes(text)
      return text unless text.present?
      text.gsub(LINK) do |match|
        title = $2
        text = $1 || title
        if title.match(/[\w\d\s\&-]+/)
          notes = Note.where("title ILIKE ?", "%#{title}%")
          if notes.count == 1
            "[#{text}](/notes/#{notes.first.id})"
          else
            match
          end
        else
          match
        end
      end
    end
  end
end
