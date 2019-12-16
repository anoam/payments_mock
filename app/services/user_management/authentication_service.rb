# frozen_string_literal: true

# Actually, we don't need an instance of this service. That's why it is a module.
module UserManagement::AuthenticationService
  # Tries to find the user with given email & password
  # @param email [String]
  # @param password [String]
  # @return Result
  def self.sign_in(email, password)
    user = UserManagement::User.find_by_email(email)

    return Result.failure(:invalid_credentials) unless user
    return Result.failure(:invalid_credentials) unless user.correct_password?(password)

    user.regenerate_token
    user.save!

    Result.success(user)
  end

  # Tries to find the user with given email & password
  # @param token [String]
  # @return Result
  def self.authenticate_by_token(token)
    user = UserManagement::User.find_by_token(token)

    return Result.failure(:invalid_token) unless user

    Result.success(user)
  end
end
