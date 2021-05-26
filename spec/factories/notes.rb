FactoryBot.define do
  factory :note do
    markdown { Faker::Lorem.paragraphs(number: 3) }
    title    { Faker::Lorem.paragraph.truncate(Note::TITLE_MAX) }
    user
  end
end
