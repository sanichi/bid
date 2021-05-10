FactoryBot.define do
  factory :user do
    admin    { [true, false].sample }
    email    { Faker::Internet.email.truncate(User::MAX_EMAIL) }
    name     { Faker::Name.name.truncate(User::MAX_NAME) }
    password { Faker::Internet.password(min_length: User::MIN_PASSWORD, special_characters: true) }
  end
end
