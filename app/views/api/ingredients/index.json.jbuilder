json.cache! @ingredients do
  json.ingredients @ingredients do |ingredient|
    json.extract! ingredient, :id, :created_at, :updated_at, :unit, :amount, :recipe_id
  end
end
