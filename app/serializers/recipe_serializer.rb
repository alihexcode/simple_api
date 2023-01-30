class RecipeSerializer < BaseSerializer
  attributes :id, :created_at, :updated_at, :title, :descriptions, :time, :difficulty, :category_id, :user_id

  has_many :ingredients
end
