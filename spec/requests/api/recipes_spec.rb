require 'swagger_helper'

RSpec.describe 'api/recipes', type: :request do
  path '/api/recipes' do
    get 'List Recipes' do
      tags 'Recipes'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, example: 1
      parameter name: :per_page, in: :query, type: :integer, example: 10
      response '200', 'successful' do
        schema type: :object,
               properties: {
                 recipes: { type: :array, items: { '$ref': '#/components/recipe' } }
               }
        pagination_headers
        let(:recipes) { create_list(:recipe, 5) }
        let(:page) { 1 }
        let(:per_page) { 10 }

        run_test!
      end
    end
  end

  path '/api/recipes/{id}' do
    get 'Show a Recipe' do
      tags 'Recipes'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'successful' do
        schema type: :object, properties: { recipe: { '$ref': '#/components/recipe' } }
        let(:id) { create(:recipe).id }

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 0 }

        run_test!
      end
    end
  end

  path '/api/recipes' do
    post 'Create a new Recipe' do
      tags 'Recipes'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :recipe_params, in: :body, schema: {
        type: :object,
        properties: {
          recipe: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Chocolate Chip Cookies' },
              descriptions: { type: :string, example: 'These classic cookies are perfect for any occasion' },
              time: { type: :integer, example: 30 },
              difficulty: { type: :string, example: 'easy' },
              category_id: { type: :integer, example: 2 }
            },
            required: %w[title descriptions time difficulty category_id]
          }
        }
      }

      response '200', 'Recipe created' do
        schema type: :object, properties: { recipe: { '$ref': '#/components/recipe' } }
        let(:Authorization) { access_token }
        let(:recipe_params) { { recipe: { title: 'Foo', difficulty: 'easy', descriptions: 'Boo', time: 120, category_id: create(:category).id } } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { access_token }
        let(:recipe_params) { { recipe: { title: Faker::Lorem.characters(number: 10_000), difficulty: 'easy', descriptions: 'Boo', time: 120, category_id: create(:category).id } } }

        run_test!
      end
    end
  end

  path '/api/recipes/{id}' do
    put 'Update a Recipe' do
      tags 'Recipes'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer
      parameter name: :recipe_params, in: :body, schema: {
        type: :object,
        properties: {
          recipe: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Chocolate Chip Cookies' },
              descriptions: { type: :string, example: 'These classic cookies are perfect for any occasion' },
              time: { type: :integer, example: 30 },
              difficulty: { type: :string, example: 'easy' },
              category_id: { type: :integer, example: 2 }
            },
            required: %w[title descriptions time difficulty category_id]
          }
        }
      }

      response '200', 'Recipe updated' do
        schema type: :object, properties: { recipe: { '$ref': '#/components/recipe' } }
        let(:recipe) { create(:recipe) }
        let(:id) { recipe.id }
        let(:Authorization) { access_token(recipe.user) }
        let(:recipe_params) { { recipe: { title: 'Foo', difficulty: 'easy', descriptions: 'Boo', time: 120, category_id: create(:category).id } } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:recipe) { create(:recipe) }
        let(:id) { recipe.id }
        let(:Authorization) { access_token(recipe.user) }
        let(:recipe_params) { { recipe: { title: Faker::Lorem.characters(number: 10_000) } } }

        run_test!
      end
    end
  end

  path '/api/recipes/{id}' do
    delete 'Deletes an Recipe' do
      tags 'Recipes'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '204', 'Recipe deleted' do
        let(:recipe) { create(:recipe) }
        let(:id) { recipe.id }
        let(:Authorization) { access_token(recipe.user) }

        run_test! do |_response|
          expect(RecipeReview.find_by(id: id)).to be_nil
        end
      end

      response '404', 'Recipe not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { access_token }

        run_test!
      end
    end
  end

  path '/api/recipes/filter' do
    get 'Filter Recipes' do
      tags 'Recipes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :title, in: :query, type: :string, example: 'foo', description: 'A string to filter the recipes by title'
      parameter name: :time_from, in: :query, type: :integer, example: 60, description: 'The start time (in minutes) to filter the recipes by time range.'
      parameter name: :time_to, in: :query, type: :integer, example: 145, description: 'The end time (in minutes) to filter the recipes by time range.'
      parameter name: :difficulty, in: :query, type: :string, example: 'easy', description: "A string to filter the recipes by difficulty. Accepts one of the following values: 'easy', 'normal', or 'challenging'."
      parameter name: :page, in: :query, type: :integer, example: 1
      parameter name: :per_page, in: :query, type: :integer, example: 10

      response '200', 'successful' do
        pagination_headers
        let(:title) { '' }
        let(:time_from) { '' }
        let(:time_to) { '' }
        let(:difficulty) { '' }
        let(:page) { 1 }
        let(:per_page) { 10 }

        let(:recipes) { create_list(:recipe, 5) }
        schema type: :object, properties: { recipes: { type: :array, items: { '$ref': '#/components/recipe' } } }

        run_test!
      end

      response '422', 'invalid range time' do
        let(:title) { '' }
        let(:time_from) { 200 }
        let(:time_to) { 10 }
        let(:difficulty) { '' }
        let(:page) { 1 }
        let(:per_page) { 10 }

        let(:recipes) { create_list(:recipe, 5) }

        run_test!
      end
    end
  end
end
