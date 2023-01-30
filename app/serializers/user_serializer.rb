class UserSerializer < BaseSerializer
  attributes :id, :created_at, :updated_at, :encrypted_password, :email, :reset_password_token,
             :reset_password_sent_at, :remember_created_at, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :sign_in_count, :password, :password_confirmation, :password

  has_many :recipes
end
