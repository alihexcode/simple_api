require 'rails_helper'

RSpec.describe RecipeReview, type: :model do
  describe 'Assocations' do
    it { is_expected.to belong_to(:recipe) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }
    let(:recipe_review) { build(:recipe_review, user: user, recipe: recipe, rating: 5, review: 'test') }

    it { expect(recipe_review).to be_valid }

    it { is_expected.to validate_presence_of(:rating) }

    context 'when rating not between 1 to 5' do
      before do
        recipe_review.rating = 0
        recipe_review.valid?
      end

      it { expect(recipe_review).not_to be_valid }
      it { expect(recipe_review.errors[:rating]).to include('must be between 1 and 5') }
    end

    it { is_expected.to validate_length_of(:review).is_at_most(1000).with_message('can be at most 1000 characters') }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:recipe_id).with_message('can only leave one review per recipe') }

    context 'when user is the recipe creator' do
      before do
        recipe_review.recipe.user_id = user.id
        recipe_review.valid?
      end

      it { expect(recipe_review).not_to be_valid }
      it { expect(recipe_review.errors.full_messages).to include("User can't review own recipe") }
    end
  end

  describe 'counter cache' do
    let(:recipe) { create(:recipe) }

    it 'increases recipe reviews count when review is created' do
      expect { create(:recipe_review, recipe: recipe) }.to change { recipe.reload.total_reviews }.by(1)
    end

    it 'decreases recipe reviews count when review is destroyed' do
      recipe_review = create(:recipe_review, recipe: recipe)
      expect { recipe_review.destroy }.to change { recipe.reload.total_reviews }.by(-1)
    end
  end
end
