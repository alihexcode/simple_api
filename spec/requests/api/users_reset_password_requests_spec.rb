require 'swagger_helper'

RSpec.describe 'api/users_reset_password_requests', type: :request do
  path '/api/users_reset_password_requests' do
    post 'Reset password request' do
      tags 'Reset password request'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :owner_fields, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@test.com' }
        }
      }

      response '200', 'request sent' do
        before { create(:user, email: 'user@test.com') }

        schema type: :object, properties: { success: { type: :boolean, example: 'true' } }
        let(:owner_fields) { { email: 'user@test.com' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_truthy
        end
      end

      response '422', 'request failed' do
        schema type: :object, properties: { success: { type: :boolean, example: 'false' } }
        let(:owner_fields) { { email: 'user@test.com' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_falsy
        end
      end
    end
  end
end
