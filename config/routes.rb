require 'sidekiq/web'

module ActionDispatch
  module Routing
    class Mapper
      def draw(routes_name)
        routes_path = Rails.root.join('config', 'routes', (@scope[:shallow_prefix]).to_s, "#{routes_name}.rb")

        instance_eval(File.read(routes_path))
      end
    end
  end
end

Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users_registrations',
               passwords: 'users/passwords'
             }

  use_doorkeeper do
    # No need to register client application
    skip_controllers :applications, :authorized_applications
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'

  namespace :api do
    devise_scope :user do
      post '/users_registrations', to: 'users_registrations#create'
    end

    put '/users_passwords', to: 'users_passwords#put_users_passwords'

    resources :users_verify_reset_password_requests, only: :create
    resources :users_reset_password_requests, only: :create
    resources :users_sessions, only: :create
    resources :ingredients, only: %i[index create show update destroy] do
      put :convert
    end
    resources :categories
    resources :recipes do
      collection do
        get :filter
      end
    end
    resources :recipe_reviews, only: %i[create show update destroy]
  end

  namespace :dashboard do
    # TODO: customizable table name
  end

  unless Rails.env.development?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      admin_username = ENV.fetch('SIDEKIQ_DASHBOARD_USERNAME', nil)
      admin_password = ENV.fetch('SIDEKIQ_DASHBOARD_PASSWORD', nil)
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(admin_username)
      ) && ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(admin_password)
      )
    end
  end
  mount Sidekiq::Web => '/sidekiq'
end
