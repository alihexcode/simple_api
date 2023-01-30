# frozen_string_literal: true

class Api::UsersVerifyResetPasswordRequestsController < Api::BaseController
  def create
    @user = User.with_reset_password_token(params[:reset_password_token])

    raise Exceptions::ResetPasswordError, 'Invalid reset token' unless @user&.reset_password(params[:password], params[:password_confirmation])

    # Successful password reset, clear reset token and return success message
    @user.update(reset_password_token: nil)
  end
end
