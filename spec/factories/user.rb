FactoryBot.define do
  factory :user do
    password { SecureRandom.hex }
    email { Faker::Internet.unique.email(domain: 'uniqexample') }
  end
end
