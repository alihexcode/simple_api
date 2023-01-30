require 'swagger_helper'

RSpec.describe 'api/users_sessions', type: :request do
  path '/api/users_sessions' do
    post 'Sign in by email' do
      tags 'Sign in by email'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :owner_fields, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@test.com' },
          password: { type: :string, example: 'dummy_password' },
          uid: { type: :string, example: 'application_uid_key' }
        }
      }

      response '200', 'user created' do
        let(:application) { create(:application) }
        schema type: :object, properties: {
          success: { type: :boolean, example: true },
          user: { '$ref': '#/components/user' },
          access_token: {
            type: :string,
            example: 'eyJra.SWtmUm7MqCPZDFaNacCfj7fe3MdEgRLHxD5kPCPFr1ZtVtCfJN279KG-8B0ehKIRHIAkGry4-452JWcp6FntJQ'
          }
        }

        let(:owner_fields) do
          {
            email: 'user_001@test.co',
            password: 'dummy_password',
            uid: application.uid
          }
        end

        before do
          user001 = create(:user, email: 'user_001@test.co')
          user001.update(password: 'dummy_password')
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_truthy
        end
      end

      response '422', 'Invalid Grant' do
        let(:application) { create(:application) }
        schema type: :object, properties: {
          success: { type: :boolean, example: false },
          message: { type: :string, example: I18n.t('doorkeeper.errors.messages.invalid_grant') }
        }

        let(:owner_fields) do
          {
            email: 'user_001@test.co',
            password: 'wrong_password',
            uid: application.uid
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['message']).to eq(I18n.t('doorkeeper.errors.messages.invalid_grant'))
        end
      end

      response '422', 'Invalid email format' do
        let(:application) { create(:application) }
        schema type: :object, properties: {
          success: { type: :boolean, example: false },
          message: { type: :string, example: 'Invalid email format' }
        }

        let(:owner_fields) do
          {
            email: 'invalid_email_format',
            password: 'dummy_password',
            uid: application.uid
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['message']).to eq('Invalid email format')
        end
      end

      response '422', 'Invalid application uid' do
        schema type: :object, properties: {
          success: { type: :boolean, example: false },
          message: { type: :string, example: 'Invalid application uid' }
        }

        let(:owner_fields) do
          {
            email: 'valid_email@example.com',
            password: 'dummy_password',
            uid: 'invalid_uid'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['message']).to eq('Invalid application uid')
        end
      end
    end
  end
end
