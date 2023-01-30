# UnitConverter module
#
# This module provides a set of class methods for performing unit conversions.
# It can be included in any ActiveRecord model to add the ability to convert
# between different units of measurement.
#
# ==== Examples
#
#   class Ingredient < ApplicationRecord
#     include UnitConverter
#   end
#
#   Ingredient.convert(1, 'kilogram', 'gram') # => 1000
#   Ingredient.convert_kilogram_to_gram(1)    # => 1000

module UnitConverter
  extend ActiveSupport::Concern

  # Define the conversion factors in terms of the reference unit (gram)
  CONVERSION_FACTORS = {
    gram: 1,                    # gram per gram      = 1
    kilogram: 1000,             # kilogram per gram  = 1000
    cup: 125.16,                # cup per gram       = 125.16    @see https://www.thecalculatorsite.com/cooking/cups-grams.php
    teaspoons: 2.61             # teaspoons per gram = 2.61      @see https://www.thecalculatorsite.com/cooking/teaspoons-grams.php
  }.with_indifferent_access

  included do
    # Converts a value from one unit to another
    #
    # @param value [Numeric] the value to be converted
    # @param from_unit [String] the unit to convert from (e.g. 'teaspoons', 'gram', 'kilogram', 'cup')
    # @param to_unit [String] the unit to convert to (e.g. 'teaspoons', 'gram', 'kilogram', 'cup')
    # @return [Numeric] the converted value
    def self.convert(value, from_unit, to_unit)
      # Validate the units
      raise ArgumentError, "Unknown unit(s): #{from_unit} and/or #{to_unit}" unless CONVERSION_FACTORS.key?(from_unit) && CONVERSION_FACTORS.key?(to_unit)

      # Convert from the from_unit to the reference unit (1 gram)
      value_in_gram = CONVERSION_FACTORS[from_unit] * value

      # Convert from the reference unit (grams) to the to_unit
      (1.0 / CONVERSION_FACTORS[to_unit] * value_in_gram)
    end
  end

  class_methods do
    CONVERSION_FACTORS.each_key.each do |from_unit|
      CONVERSION_FACTORS.each_key.each do |to_unit|
        # Define all possible conversion methods convert_<from_unit>_to_<to_unit>(value)
        # @param value [Numeric] the value to be converted
        #
        # ==== Examples
        #  Ingredient.convert_kilogram_to_gram(1)  # => 1000
        define_method("convert_#{from_unit}_to_#{to_unit}") do |value|
          convert(value, from_unit, to_unit)
        end
      end
    end
  end
end
