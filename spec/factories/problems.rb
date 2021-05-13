FactoryBot.define do
  factory :problem do
    sequence(:hand) { |i| Hand::EXAMPLES[i % Hand::EXAMPLES.length] }
    sequence(:bids) { |i| Bids::EXAMPLES[i % Bids::EXAMPLES.length] }
    vul             { Problem::VULS.sample }
    note            { Faker::Lorem.paragraphs(number: 3) }
    user
  end
end
