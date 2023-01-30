class Category < ApplicationRecord
  include ConstantValidatable

  has_many :recipes, dependent: :destroy

  has_many :ingredients, through: :recipes

  validates :description, length: { maximum: 65_535, minimum: 0, message: I18n.t('.out_of_range_error') },
                          allow_nil: true

  accepts_nested_attributes_for :recipes

  def self.associations
    %i[recipes ingredients]
  end
end
