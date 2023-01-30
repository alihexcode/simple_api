require 'swagger_helper'

RSpec.describe 'api/recipe_reviews', type: :request do
  path '/api/recipe_reviews/{id}' do
    get 'Show recipe review' do
      tags 'Recipe Reviews'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'successful' do
        schema type: :object, properties: { recipe_review: { '$ref': '#/components/recipe_review' } }
        let(:id) { create(:recipe_review).id }

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 0 }

        run_test!
      end
    end
  end

  path '/api/recipe_reviews' do
    post 'Create a new recipe review' do
      tags 'Recipe Reviews'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :recipe_review_params, in: :body, schema: {
        type: :object,
        properties: {
          recipe_review: {
            type: :object,
            properties: {
              review: { type: :string, example: 'Foo' },
              rating: { type: :integer, example: 5 },
              recipe_id: { type: :integer, example: 1 }
            },
            required: %w[review rating recipe_id]
          }
        }
      }

      response '200', 'recipe review created' do
        schema type: :object, properties: { recipe_review: { '$ref': '#/components/recipe_review' } }
        let(:Authorization) { access_token }
        let(:recipe_review_params) { { recipe_review: { review: 'good recipe', rating: 4, recipe_id: create(:recipe).id } } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { access_token }
        let(:recipe_review_params) { { recipe_review: { review: 'good recipe', rating: 10, recipe_id: 'invalid' } } }

        run_test!
      end
    end
  end

  path '/api/recipe_reviews/{id}' do
    put 'Update a recipe review' do
      tags 'Recipe Reviews'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer
      parameter name: :recipe_review_params, in: :body, schema: {
        type: :object,
        properties: {
          recipe_review: {
            type: :object,
            properties: {
              review: { type: :string, example: 'Foo' },
              rating: { type: :integer, example: 5 },
              recipe_id: { type: :integer, example: 1 }
            },
            required: %w[review rating recipe_id]
          }
        }
      }

      response '200', 'recipe review updated' do
        schema type: :object, properties: { recipe_review: { '$ref': '#/components/recipe_review' } }
        let(:recipe_review) { create(:recipe_review) }
        let(:id) { recipe_review.id }
        let(:Authorization) { access_token(recipe_review.user) }
        let(:recipe_review_params) { { recipe_review: { review: 'good recipe', rating: 4, recipe_id: create(:recipe).id } } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:recipe_review) { create(:recipe_review) }
        let(:id) { recipe_review.id }
        let(:Authorization) { access_token(recipe_review.user) }
        let(:recipe_review_params) { { recipe_review: { review: '', rating: 10, recipe_id: 'invalid' } } }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:recipe_review) { create(:recipe_review) }
        let(:id) { recipe_review.id }
        let(:Authorization) { access_token }
        let(:recipe_review_params) { { recipe_review: { review: '', rating: 10, recipe_id: 'invalid' } } }

        run_test!
      end
    end
  end

  path '/api/recipe_reviews/{id}' do
    delete 'Deletes an recipe review' do
      tags 'Recipe Reviews'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '204', 'recipe review deleted' do
        let(:recipe_review) { create(:recipe_review) }
        let(:id) { recipe_review.id }
        let(:Authorization) { access_token(recipe_review.user) }

        run_test! do |_response|
          expect(RecipeReview.find_by(id: id)).to be_nil
        end
      end

      response '404', 'recipe review not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { access_token }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:recipe_review) { create(:recipe_review) }
        let(:id) { recipe_review.id }
        let(:Authorization) { access_token }

        run_test!
      end
    end
  end
end
