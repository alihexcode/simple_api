json.cache! @categories do
  json.categories @categories do |category|
    json.extract! category, :id, :description, :created_at, :updated_at

    json.recipes category.recipes do |recipe|
      json.extract! recipe, :id, :title, :descriptions, :time_in_word, :difficulty, :category_id, :user_id, :total_reviews, :rating, :created_at, :updated_at

      json.ingredients recipe.ingredients do |ingredient|
        json.extract! ingredient, :id, :unit, :amount, :recipe_id, :created_at, :updated_at
      end
    end
  end
end
