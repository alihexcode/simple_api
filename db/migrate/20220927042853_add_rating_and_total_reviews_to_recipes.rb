class AddRatingAndTotalReviewsToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :total_reviews, :integer, default: 0
    add_column :recipes, :rating, :float, limit: 24, default: 0.0
  end
end
