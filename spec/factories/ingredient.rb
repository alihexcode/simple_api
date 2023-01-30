FactoryBot.define do
  factory :ingredient do
    recipe
    amount { 1.0 }
    unit { 'cup' }
  end
end
