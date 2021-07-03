FactoryBot.define do
  factory :problem do
    sequence(:hand) { |i| Hand::EXAMPLES[i % Hand::EXAMPLES.length] }
    sequence(:bids) { |i| Bids::EXAMPLES[i % Bids::EXAMPLES.length] }
    vul             { Problem::VULS.sample }
    category        { Faker::Lorem.words(number: 3).join(" ") }
    note            { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    user
  end
end
