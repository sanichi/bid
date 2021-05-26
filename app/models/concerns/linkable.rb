module Linkable
  extend ActiveSupport::Concern

  LINK = /
    \{
      (?:([^}|]+)\|)?
      ([^}|]+)
    \}
  /x

  SourcesTargets = Struct.new(:sources, :targets)

  included do
    def link_notes(text)
      return text unless text.present?
      text.gsub(LINK) do |match|
        title = $2
        text = $1 || title
        if title.match(Note::TITLE_FORMAT)
          notes = Note.targets(title)
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

  class_methods do
    def note_links
      links = Hash.new { |hash, key| hash[key] = SourcesTargets.new(Set.new, Set.new) }
      Note.all.each do |note|
        note.markdown.scan(LINK) do |text, title|
          links[title].sources.add(note)
          if title.match(Note::TITLE_FORMAT)
            Note.targets(title).each{ |n| links[title].targets.add(n) }
          end
        end
      end
      Problem.all.each do |prob|
        prob.note.scan(LINK) do |text, title|
          links[title].sources.add(prob)
          if title.match(Note::TITLE_FORMAT)
            Note.targets(title).each{ |n| links[title].targets.add(n) }
          end
        end
      end
      links
    end
  end
end
