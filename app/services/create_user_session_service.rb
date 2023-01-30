class CreateUserSessionService
  attr_reader :error_message, :user

  # Initialize the service with the given params
  #
  # @param [Hash] params The params passed to the service
  # @option params [String] :email The email of the user
  # @option params [String] :password The password of the user
  # @option params [String] :uid The uid of the application
  def initialize(params)
    @params = params
    @user = User.find_by(email: params[:email])
    @application = Doorkeeper::Application.find_by(uid: params[:uid])
    @password = params[:password]
  end

  # Check if the provided credentials are valid
  #
  # @return [Boolean] true if the credentials are valid, false otherwise
  # @raise [Exceptions::InvalidCredentials] if invalid
  def valid?
    raise Exceptions::InvalidCredentials, 'Invalid email format' unless valid_email?
    raise Exceptions::InvalidCredentials, 'Invalid application uid' unless valid_application?
    raise Exceptions::InvalidCredentials, I18n.t('doorkeeper.errors.messages.invalid_grant') unless valid_credentials?

    true
  end

  # Generate a new token
  #
  # @return [Doorkeeper::AccessToken] The generated access token
  def generate_access_token
    Doorkeeper::AccessToken.create!(resource_owner: @user, application_id: @application.id)
  end

  private

  # Check if the provided credentials are valid
  #
  # @return [Boolean] true if the credentials are valid, false otherwise
  def valid_credentials?
    @user&.valid_password?(@password)
  end

  # Check if the provided application uid is valid
  #
  # @return [Boolean] true if the application uid is valid, false otherwise
  def valid_application?
    @application.present?
  end

  # Check if the provided email is valid
  #
  # @return [Boolean] true if the email is valid, false otherwise
  def valid_email?
    @params[:email].match?(URI::MailTo::EMAIL_REGEXP)
  end
end
