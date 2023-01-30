RSpec.describe RecipesFilterService do
  describe '#call' do
    let!(:recipe1) { create(:recipe, title: 'Foo', time: '30', difficulty: :easy) }
    let!(:recipe2) { create(:recipe, title: 'Bar', time: '60', difficulty: :normal) }
    let!(:recipe3) { create(:recipe, title: 'Baz', time: '90', difficulty: :challenging) }

    context 'when no filters are applied' do
      it 'returns all recipes' do
        service = described_class.new({})
        expect(service.call).to match_array([recipe1, recipe2, recipe3])
      end
    end

    context 'when filtering by title' do
      it 'returns only recipes with matching titles' do
        service = described_class.new(title: 'Foo')
        expect(service.call).to match_array([recipe1])
      end
    end

    context 'when filtering by time range' do
      it 'returns only recipes within the time range' do
        service = described_class.new(time_from: '30', time_to: '60')
        expect(service.call).to match_array([recipe1, recipe2])
      end

      it 'raises an error if the time range is invalid' do
        service = described_class.new(time_from: '60', time_to: '30')
        expect { service.call }.to raise_error(ArgumentError, 'Invalid time range: time_from must be less than or equal to time_to')
      end
    end

    context 'when filtering by difficulty' do
      it 'returns only recipes with matching difficulty' do
        service = described_class.new(difficulty: 'challenging')
        expect(service.call).to match_array([recipe3])
      end
    end
  end
end
