require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:recipe) do
    build(:recipe)
  end

  describe 'Assocations' do
    it { is_expected.to have_many(:ingredients) }

    it { is_expected.to belong_to(:category) }

    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:recipe_reviews) }
  end

  describe 'Valid subject' do
    it 'is valid recipe' do
      expect(recipe).to be_valid
    end
  end

  describe 'Invalid length validations' do
    it 'is invalid max length' do
      recipe.title = 'a' * 256
      expect(recipe).not_to be_valid
    end

    it 'is invalid max length' do
      recipe.descriptions = 'a' * 65_536
      expect(recipe).not_to be_valid
    end

    it 'is invalid max length' do
      recipe.time = 'a' * 256
      expect(recipe).not_to be_valid
    end
  end

  describe 'Invalid enum validations' do
    it 'is invalid enum value' do
      recipe = Recipe.new
      expect do
        recipe.difficulty = 'invalid_enum'
      end.to raise_error(ArgumentError, "'invalid_enum' is not a valid difficulty")
    end
  end

  describe 'Validate presence' do
    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_presence_of(:descriptions) }

    it { is_expected.to validate_presence_of(:time) }

    it { is_expected.to validate_presence_of(:difficulty) }
  end
end
