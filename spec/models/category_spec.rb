require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) do
    build(:category)
  end

  describe 'Assocations' do
    it { is_expected.to have_many(:recipes) }
    it { is_expected.to have_many(:ingredients) }
  end

  describe 'Valid subject' do
    it 'is valid category' do
      expect(category).to be_valid
    end
  end

  describe 'Invalid length validations' do
    it 'is invalid max length' do
      category.description = 'a' * 65_536
      expect(category).not_to be_valid
    end
  end
end
