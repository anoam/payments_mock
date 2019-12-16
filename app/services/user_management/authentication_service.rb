# frozen_string_literal: true

# Actually, we don't need an instance of this service. That's why it is a module.
module UserManagement::AuthenticationService
  # Tries to find the user with given email & password
  # @param email [String]
  # @param password [String]
  # @return Result
  def self.sign_in(email, passowrd)

  end

  # Tries to find the user with given email & password
  # @param token [String]
  # @return Result
  def self.authenticate_by_token(token)

  end
end
