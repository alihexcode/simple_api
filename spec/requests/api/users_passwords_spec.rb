require 'swagger_helper'

RSpec.describe 'api/users_passwords', type: :request do
  path '/api/users_passwords' do
    put 'Change password' do
      tags 'Change password'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :new_password, in: :body, schema: {
        type: :object,
        properties: {
          new_password: { type: :string, example: 'dummy_new_password' }
        },
        required: %w[dummy_new_password]
      }

      let(:resource_owner) { create(:user) }
      let(:Authorization) { access_token(resource_owner) }

      response '200', 'Password updated' do
        schema type: :object, properties: { success: { type: :boolean, example: 'true' } }

        let(:new_password) { { new_password: 'dummy_new_password' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_truthy
        end
      end

      response '422', 'Cannot update password' do
        schema type: :object, properties: { success: { type: :boolean, example: 'false' } }

        let(:new_password) { { new_password: '1' } }

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['success']).to be_falsy
        end
      end
    end
  end
end
