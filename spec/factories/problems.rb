FactoryBot.define do
  factory :problem do
    sequence(:hand) { |i| Hand::EXAMPLES[i % Hand::EXAMPLES.length] }
    bids            { Faker::Name.name }
    vul             { Problem::VULS.sample }
    note            { Faker::Lorem.paragraphs(number: 3) }
    draft           { [true, false].sample }
    user
  end
end
