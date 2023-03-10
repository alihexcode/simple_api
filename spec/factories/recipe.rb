FactoryBot.define do
  factory :recipe do
    category
    user
    difficulty { 'easy' }
    time { Faker::Lorem.paragraph_by_chars(number: rand(0..255)) }
    descriptions { Faker::Lorem.paragraph_by_chars(number: rand(0..1000)) }
    title { Faker::Lorem.paragraph_by_chars(number: rand(0..255)) }
  end
end
