class RecipeReview < ApplicationRecord
  belongs_to :recipe, counter_cache: :total_reviews
  belongs_to :user

  before_validation :ensure_user_is_not_recipe_creator
  after_commit :calculate_avg_rating, on: :create

  validates :rating, presence: true, inclusion: { in: 1..5, message: I18n.t('errors.recipe_review.rating.inclusion') }
  validates :review, length: { maximum: 1000, message: I18n.t('errors.recipe_review.review.too_long') }
  validates :user_id, uniqueness: { scope: :recipe_id, message: I18n.t('errors.recipe_review.user_id.taken') }

  def self.associations
    %i[recipe user]
  end

  def calculate_avg_rating
    return if recipe.blank?

    recipe.rating = recipe.recipe_reviews.average(:rating).to_f.round(1)
    recipe.save
  end

  private

  def ensure_user_is_not_recipe_creator
    return if recipe.blank?

    errors.add(:user, I18n.t('errors.recipe_review.user.cant_review_own_recipe')) if user == recipe.user
  end
end
