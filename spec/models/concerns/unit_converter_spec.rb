require 'rails_helper'

class DummyModel < ApplicationRecord
  include UnitConverter
end

RSpec.describe UnitConverter do
  describe '.convert' do
    context 'when the units are valid' do
      it 'converts the value from one unit to another' do
        expect(DummyModel.convert(1, 'kilogram', 'gram')).to eq(1000)
      end

      it 'converts teaspoons to gram' do
        expect(DummyModel.convert(1, 'teaspoons', 'gram')).to eq(2.61)
      end

      it 'converts cup to gram' do
        expect(DummyModel.convert(1, 'cup', 'gram')).to eq(125.16)
      end

      it 'converts gram to kilogram' do
        expect(DummyModel.convert(1, 'gram', 'kilogram')).to eq(0.001)
      end
    end

    context 'when the units are invalid' do
      it 'raises an ArgumentError when from_unit is invalid' do
        expect { DummyModel.convert(1, 'invalid_unit', 'gram') }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when to_unit is invalid' do
        expect { DummyModel.convert(1, 'kilogram', 'invalid_unit') }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when both from_unit and to_unit are invalid' do
        expect { DummyModel.convert(1, 'invalid_unit', 'invalid_unit') }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'conversion methods' do
    it { expect(DummyModel).to respond_to(:convert_kilogram_to_gram) }
    it { expect(DummyModel).to respond_to(:convert_teaspoons_to_gram) }
    it { expect(DummyModel).to respond_to(:convert_cup_to_gram) }

    context 'when converting to gram' do
      it 'converts the value from kilogram to gram' do
        expect(DummyModel.convert_kilogram_to_gram(1)).to eq(1000)
      end

      it 'converts the value from teaspoons to gram' do
        expect(DummyModel.convert_teaspoons_to_gram(1)).to eq(2.61)
      end

      it 'converts the value from cup to gram' do
        expect(DummyModel.convert_cup_to_gram(1)).to eq(125.16)
      end
    end
  end
end
