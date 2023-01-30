module Exceptions
  class AuthenticationError < StandardError; end
  class InvalidCredentials < StandardError; end
  class RegistrationError < StandardError; end
  class ResetPasswordError < StandardError; end
end
