require 'swagger_helper'

RSpec.describe 'api/users_verify_reset_password_requests', type: :request do
  path '/api/users_verify_reset_password_requests' do
    post 'Verify reset password request' do
      tags 'Verify reset password request'
      consumes 'application/json'

      parameter name: :owner_fields, in: :body, schema: {
        type: :object,
        properties: {
          reset_password_token: { type: :string, example: 'dummy_reset_password_token' },
          password: { type: :string, example: 'dummy_password' },
          password_confirmation: { type: :string, example: 'dummy_password' }
        }
      }

      response '200', 'request sent' do
        let(:user) { User.find_by(email: 'user@test.com') || create(:user, email: 'user@test.com') }
        let(:token) { user.generate_reset_password_token }

        schema type: :object, properties: {
          success: { type: :boolean, example: true }
        }

        let(:owner_fields) do
          {
            reset_password_token: token,
            password: 'dummy_password',
            password_confirmation: 'dummy_password'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_truthy
        end
      end

      response '422', 'failed to change password' do
        let(:user) { User.find_by(email: 'user@test.com') || create(:user, email: 'user@test.com') }

        schema type: :object, properties: {
          success: { type: :boolean, example: false }
        }

        let(:owner_fields) do
          {
            reset_password_token: 'asd',
            password: 'dummy_password',
            password_confirmation: 'dummy_password'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_falsy
        end
      end
    end
  end
end
