json.category do
  json.extract! category, :id, :description, :created_at, :updated_at

  json.cache! category.recipes do |recipe|
    json.recipes category.recipes, :id, :title, :descriptions, :time_in_word, :difficulty, :category_id, :user_id, :total_reviews, :created_at, :updated_at

    json.ingredients recipe.ingredients do |ingredient|
      json.extract! ingredient, :id, :unit, :amount, :recipe_id, :created_at, :updated_at
    end
  end
end
