require 'swagger_helper'

RSpec.describe 'api/users_registrations', type: :request do
  path '/api/users_registrations' do
    post 'Sign up by email' do
      tags 'Sign up by email'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :owner_fields, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@test.com' },
              password: { type: :string, example: 'dummy_password' },
              password_confirmation: { type: :string, example: 'dummy_password' }
            }
          }
        }
      }

      response '200', 'user created' do
        schema type: :object, properties: {
          success: { type: :boolean, example: true },
          user: { '$ref': '#/components/user' }
        }

        let(:owner_fields) do
          {
            user: {
              email: 'user_1@test.co',
              password: 'dummy_password',
              password_confirmation: 'dummy_password'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_truthy
        end
      end

      response '422', 'Cannot register' do
        schema type: :object, properties: {
          success: { type: :boolean, example: false },
          message: { type: :string, example: I18n.t('email_login.failed_to_sign_up', error_message: 'Invalid email format') }
        }

        let(:owner_fields) do
          {
            user: {
              email: 'invalid_email',
              password: 'dummy_password',
              password_confirmation: 'dummy_password'
            }
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
