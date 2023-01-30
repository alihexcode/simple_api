# frozen_string_literal: true

class Api::UsersResetPasswordRequestsController < Api::BaseController
  def create
    user = User.find_by(email: params[:email])

    if user
      user.send_reset_password_instructions
      @success = true
    else
      @error_message = 'Your email is not registered'
      @success = false
      render status: :unprocessable_entity
    end
  end
end
