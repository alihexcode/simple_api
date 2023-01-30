# frozen_string_literal: true

class Api::UsersPasswordsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def put_users_passwords
    current_user.update!(password: params[:new_password])
  end
end
