json.ingredient do
  json.extract! ingredient, :id, :created_at, :updated_at, :unit, :amount, :recipe_id
end
