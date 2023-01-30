FactoryBot.define do
  factory :recipe_review do
    recipe
    user
    rating { rand(1..5) }
    review { Faker::Lorem.paragraph_by_chars(number: rand(0..255)) }
  end
end
