class CreateRecipeReview < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_reviews do |t|
      t.references :user
      t.references :recipe
      t.text :review
      t.float :rating, limit: 24, default: 0.0

      t.timestamps
    end

    add_index :recipe_reviews, [:user_id, :recipe_id], unique: true
  end
end
