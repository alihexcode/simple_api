require 'swagger_helper'

RSpec.describe 'api/categories', type: :request do
  path '/api/categories' do
    get 'List Categories' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, example: 1
      parameter name: :per_page, in: :query, type: :integer, example: 10

      response '200', 'successful' do
        schema type: :object,
               properties: {
                 categories: { type: :array, items: { '$ref': '#/components/category' } }
               }
        pagination_headers
        let(:page) { 1 }
        let(:per_page) { 10 }
        let(:categories) { create_list(:category, 5) }

        run_test!
      end
    end
  end

  path '/api/categories/{id}' do
    parameter name: :id, in: :path, type: :integer
    get 'Show category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'successful' do
        schema type: :object, properties: { category: { '$ref': '#/components/category' } }
        let(:id) { create(:category).id }

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end

  path '/api/categories' do
    post 'Create a new category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :category_params, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              description: { type: :string, example: 'Description' }
            }
          }
        }
      }

      response '200', 'category created' do
        schema type: :object, properties: { category: { '$ref': '#/components/category' } }
        let(:category_params) { { category: { description: 'New Description' } } }
        let(:Authorization) { access_token }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:category_params) { { category: { description: 'New Description' } } }
        let(:Authorization) {}
        run_test!
      end

      response '422', 'Unprocessable entity' do
        let(:category_params) { { category: { description: Faker::Lorem.characters(number: 100_000) } } }
        let(:Authorization) { access_token }

        run_test!
      end
    end
  end

  path '/api/categories/{id}' do
    put 'Updates a category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer
      parameter name: :category_params, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              description: { type: :string, example: 'Description' }
            }
          }
        }
      }

      response '200', 'category updated' do
        schema type: :object, properties: { category: { '$ref': '#/components/category' } }
        let(:id) { create(:category).id }
        let(:category_params) { { category: { description: 'Update a description' } } }
        let(:Authorization) { access_token }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:category).id }
        let(:category_params) { { category: { description: 'Update a description' } } }
        let(:Authorization) {}

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        let(:category_params) { { category: { description: 'Update a description' } } }
        let(:Authorization) { access_token }

        run_test!
      end
    end
  end

  path '/api/categories/{id}' do
    delete 'Deletes a category' do
      tags 'Categories'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '204', 'category deleted' do
        let(:category) { create(:category) }
        let(:id) { category.id }
        let(:Authorization) { access_token }

        run_test!
      end

      response '404', 'category not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { access_token }

        run_test!
      end
    end
  end
end
