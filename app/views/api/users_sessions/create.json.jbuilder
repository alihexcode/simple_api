json.success true
json.user do
  json.extract! @user, :id, :email, :created_at, :updated_at
end

json.access_token @access_token.token
