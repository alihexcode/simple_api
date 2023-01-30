json.recipe do
  json.extract! @recipe, :id, :created_at, :updated_at, :title, :descriptions, :time_in_word, :difficulty, :category_id, :user_id, :total_reviews

  json.cache! @recipe.ingredients do
    json.ingredients @recipe.ingredients do |ingredient|
      json.extract! ingredient, :id, :created_at, :updated_at, :unit, :amount, :recipe_id
    end
  end

  json.cache! @recipe.recipe_reviews do
    json.reviews @recipe.recipe_reviews do |review|
      json.extract! review, :id, :created_at, :updated_at, :review, :rating, :recipe_id

      json.user do
        json.extract! review.user, :id, :email
      end
    end
  end
end
