class Recipe < ApplicationRecord
  include ConstantValidatable

  has_many :ingredients, dependent: :destroy

  has_many :recipe_reviews, dependent: :destroy

  belongs_to :category

  belongs_to :user

  enum difficulty: %w[easy normal challenging], _suffix: true

  validates :title, length: { maximum: 255, minimum: 0, message: I18n.t('errors.out_of_range_error', min: 0, max: 255) }, presence: true

  validates :descriptions, length: { maximum: 65_535, minimum: 0, message: I18n.t('errors.out_of_range_error', min: 0, max: 65_535) },
                           presence: true

  validates :time, length: { maximum: 255, minimum: 0, message: I18n.t('errors.out_of_range_error', min: 0, max: 255) }, presence: true

  validates :difficulty, presence: true

  accepts_nested_attributes_for :ingredients

  def self.associations
    [:ingredients, { recipe_reviews: :user }]
  end

  # converting time(minutes) in to word
  def time_in_word
    minutes = time.to_i
    hours = minutes / 60
    minutes = minutes % 60

    if hours.zero?
      "#{minutes} #{I18n.t('time.minute', count: minutes)}"
    elsif minutes.zero?
      "#{hours} #{I18n.t('time.hour', count: hours)}"
    else
      "#{hours} #{I18n.t('time.hour', count: hours)} #{minutes} #{I18n.t('time.minute', count: minutes)}"
    end
  end
end
