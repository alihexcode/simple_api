class Ingredient < ApplicationRecord
  include ConstantValidatable
  include UnitConverter

  belongs_to :recipe

  enum unit: %w[cup teaspoons gram kilogram], _suffix: true

  validates :unit, presence: true

  validates :amount,
            numericality: { greater_than: 0.0, less_than: 3.402823466e+38, message: I18n.t('.out_of_range_error') }, presence: true
end
