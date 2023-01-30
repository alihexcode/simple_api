require 'swagger_helper'
RSpec.describe 'api/ingredients', type: :request do
  path '/api/ingredients' do
    get 'List Ingredients' do
      tags 'Ingredients'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, example: 1
      parameter name: :per_page, in: :query, type: :integer, example: 10

      response '200', 'successful' do
        pagination_headers
        let(:ingredients) { create_list(:ingredient, 5) }
        let(:page) { 1 }
        let(:per_page) { 10 }
        schema type: :object,
               properties: {
                 ingredients: { type: :array, items: { '$ref': '#/components/ingredient' } }
               }

        run_test!
      end
    end
  end

  path '/api/ingredients/{id}' do
    get 'Show ingredient' do
      tags 'Ingredients'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'successful' do
        schema type: :object, properties: { ingredient: { '$ref': '#/components/ingredient' } }
        let(:id) { create(:ingredient).id }

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 0 }

        run_test!
      end
    end
  end

  path '/api/ingredients' do
    post 'Create a new ingredient' do
      tags 'Ingredients'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :ingredient_params, in: :body, schema: {
        type: :object,
        properties: {
          ingredient: {
            type: :object,
            properties: {
              unit: { type: :string, example: 'cup' },
              amount: { type: :integer, example: 100 },
              recipe_id: { type: :integer, example: 1 }
            },
            required: %w[unit amount recipe_id]
          }
        }
      }

      response '200', 'ingredient created' do
        schema type: :object, properties: { ingredient: { '$ref': '#/components/ingredient' } }
        let(:Authorization) { access_token }
        let(:ingredient_params) { { ingredient: { unit: 'teaspoons', amount: 2, recipe_id: create(:recipe).id } } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { access_token }
        let(:ingredient_params) { { ingredient: { unit: '', amount: 0, recipe_id: 0 } } }

        run_test!
      end
    end
  end

  path '/api/ingredients/{id}' do
    put 'Updates a ingredient' do
      tags 'Ingredients'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer
      parameter name: :ingredient_params, in: :body, schema: {
        type: :object,
        properties: {
          ingredient: {
            type: :object,
            properties: {
              unit: { type: :string, example: 'cup' },
              amount: { type: :integer, example: 100 },
              recipe_id: { type: :integer, example: 1 }
            },
            required: %w[unit amount recipe_id]
          }
        }
      }

      response '200', 'ingredient updated' do
        schema type: :object, properties: { ingredient: { '$ref': '#/components/ingredient' } }
        let(:id) { create(:ingredient).id }
        let(:ingredient_params) { { ingredient: { unit: 'teaspoons', amount: 2, recipe_id: create(:recipe).id } } }
        let(:Authorization) { access_token }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:ingredient).id }
        let(:ingredient_params) { { ingredient: { unit: 'teaspoons', amount: 2, recipe_id: create(:recipe).id } } }
        let(:Authorization) {}

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        let(:ingredient_params) { { ingredient: { unit: 'teaspoons', amount: 2, recipe_id: create(:recipe).id } } }
        let(:Authorization) { access_token }

        run_test!
      end
    end
  end

  path '/api/ingredients/{id}' do
    delete 'Deletes an ingredient' do
      tags 'Ingredients'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '204', 'ingredient deleted' do
        let(:ingredient) { create(:ingredient) }
        let(:id) { ingredient.id }
        let(:Authorization) { access_token }

        run_test! do |_response|
          expect(Ingredient.find_by(id: id)).to be_nil
        end
      end

      response '404', 'ingredient not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { access_token }

        run_test!
      end
    end
  end

  path '/api/ingredients/{id}/convert' do
    put 'Convert ingredient unit' do
      tags 'Ingredients'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :to_unit_param, in: :body, schema: {
        type: :object,
        properties: {
          to_unit: { type: :string, example: 'teaspoons' }
        },
        required: ['to_unit']
      }
      let(:id) { create(:ingredient).id }
      let(:to_unit_param) { { to_unit: 'teaspoons' } }

      response '200', 'unit converted' do
        schema type: :object, properties: { ingredient: { '$ref': '#/components/ingredient' } }

        run_test!
      end

      response '404', 'ingredient not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '422', 'invalid unit' do
        let(:to_unit_param) { { to_unit: 'meter' } }

        run_test!
      end
    end
  end
end
