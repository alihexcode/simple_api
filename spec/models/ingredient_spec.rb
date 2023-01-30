require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let(:ingredient) do
    build(:ingredient)
  end

  describe 'Assocations' do
    it { is_expected.to belong_to(:recipe) }
  end

  describe 'Valid subject' do
    it 'is valid ingredient' do
      expect(ingredient).to be_valid
    end
  end

  describe 'Invalid numeric validations' do
    it 'is invalid greater than / equal to value' do
      ingredient.amount = -10.0
      expect(ingredient).not_to be_valid
    end

    it 'is invalid less than / equal to value' do
      ingredient.amount = 3.402823466e+38
      expect(ingredient).not_to be_valid
    end
  end

  describe 'Invalid enum validations' do
    it 'is invalid enum value' do
      ingredient = Ingredient.new
      expect { ingredient.unit = 'invalid_enum' }.to raise_error(ArgumentError, "'invalid_enum' is not a valid unit")
    end
  end

  describe 'Validate presence' do
    it { is_expected.to validate_presence_of(:unit) }

    it { is_expected.to validate_presence_of(:amount) }
  end
end
