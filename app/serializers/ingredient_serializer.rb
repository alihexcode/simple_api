class IngredientSerializer < BaseSerializer
  attributes :id, :created_at, :updated_at, :unit, :amount, :recipe_id
end
