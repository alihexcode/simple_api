# frozen_string_literal: true

class Api::UsersRegistrationsController < Api::BaseController
  def create
    @user = User.new(sign_up_params)

    return if @user.save

    raise Exceptions::RegistrationError,
          I18n.t('email_login.failed_to_sign_up',
                 error_message: @user.errors.full_messages.to_sentence)
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
