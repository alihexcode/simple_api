FactoryBot.define do
  factory :category do
    description { Faker::Lorem.paragraph_by_chars(number: rand(0..1000)) }
  end
end
