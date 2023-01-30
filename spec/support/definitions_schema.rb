# This file defines schemas for swagger documentation.
# The schemas are used to validate the structure and properties of the objects and to provide examples in the documentation.
# Usage: used in the swagger_helper.rb file to define the structure of the objects in the components section.

CATEGORY_SCHEMA = {
  type: :object,
  required: %i[id description],
  properties: {
    id: { type: :integer, example: 1 },
    created_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' },
    updated_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' },
    description: { type: :string, example: 'This category has the most delicious recipes!' },
    recipes: {
      type: :array,
      items: { '$ref': '#/components/recipe' }
    }
  }
}

RECIPE_SCHEMA = {
  type: :object,
  required: %i[id title descriptions time_in_word difficulty],
  properties: {
    id: { type: :integer, example: 2 },
    title: { type: :string, example: 'Delicious Recipe' },
    descriptions: { type: :string, example: 'This recipe is so delicious!' },
    time_in_word: { type: :string, example: '45 minutes' },
    difficulty: { type: :string, example: 'easy' },
    ingredients: {
      type: :array,
      items: { '$ref': '#/components/ingredient' }
    },
    recipe_reviews: {
      type: :array,
      items: { '$ref': '#/components/recipe_review' }
    },
    created_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' },
    updated_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' }
  }
}

INGREDIENT_SCHEMA = {
  type: :object,
  required: %i[id unit amount],
  properties: {
    id: { type: :integer, example: 2 },
    unit: { type: :string, example: 'cup' },
    recipe_id: { type: :integer, example: 1 },
    amount: { type: :number, example: 30 },
    created_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' },
    updated_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' }
  }
}

RECIPE_REVIEW_SCHEMA = {
  type: :object,
  required: %i[id review rating],
  properties: {
    id: { type: :integer, example: 2 },
    review: { type: :string, example: 'Good recipe' },
    rating: { type: :number, example: 5 },
    user: { '$ref': '#/components/user' },
    created_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' },
    updated_at: { type: :string, format: :datetime, example: '2023-01-09T20:49:24.426+07:00' }
  }
}

USER_SCHEMA = {
  type: :object,
  required: %i[id email],
  properties: {
    id: { type: :integer, example: 2 },
    email: { type: :string, example: 'example@mail.com' },
    created_at: { type: :string, format: :datetime, example: '2023-01-23T00:07:12.777+07:00' },
    updated_at: { type: :string, format: :datetime, example: '2023-01-23T00:07:12.779+07:00' }
  }
}
