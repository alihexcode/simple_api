json.recipe_review do
  json.extract! recipe_review, :id, :created_at, :updated_at, :review, :rating, :recipe_id

  json.user do
    json.extract! recipe_review.user, :id, :email
  end
end
