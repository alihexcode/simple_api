module Authentication
  def access_token(user = nil)
    user = user.presence || create(:user)
    "Bearer #{create(:access_token, resource_owner: user).token}"
  end
end
