# frozen_string_literal: true

class Api::UsersSessionsController < Api::BaseController
  def create
    service = CreateUserSessionService.new(params)
    @access_token = service.generate_access_token if service.valid?
    @user = service.user
  end
end
