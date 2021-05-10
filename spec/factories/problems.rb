FactoryBot.define do
  factory :problem do
    hand  { Faker::Name.name.truncate(Problem::MAX_HAND) }
    bids  { Faker::Name.name }
    vul   { Problem::VULS.sample }
    note  { Faker::Lorem.paragraphs(number: 3) }
    draft { [true, false].sample }
    user
  end
end
