# frozen_string_literal: true

# Base class for users of the Application
# @abstract
class UserManagement::User < ApplicationRecord
  class << self
    # Tries to find a user with given email
    # @param email [String]
    # @return [User]
    def find_by_email(email)
      find_by(email: email)
    end

    # Tries to find a user with given token
    # @param token [String]
    # @return [User]
    def find_by_token(token)
      find_by(token: token)
    end

    # Checks weather given string is a valid email
    # @param email [String]
    # @return [Boolean]
    def valid_email?(email)
      URI::MailTo::EMAIL_REGEXP.match?(email)
    end

    # Checks weather given string can be used as a user's password
    # @param password [String]
    # @return [Boolean]
    def valid_password?(password)
      password.present? && password.length >= 3
    end
  end

  # Sets new email
  # @raise [ArgumentError] if given string isn't fine as an email
  def email=(email)
    raise ArgumentError, 'Invalid email' unless self.class.valid_email?(email)
    super
  end

  # Sets new password for the user
  # @raise [ArgumentError] if given string isn't fine as a password
  # @param password [String]
  def password=(password)
    raise ArgumentError, 'Insufficient password' unless self.class.valid_password?(password)

    self.encrypted_password = BCrypt::Password.create(password)
  end

  # Checks weather the the given password match stored one
  # @param password [String]
  def correct_password?(password)
    BCrypt::Password.new(encrypted_password) == password
  end

  # Update authentication token
  def regenerate_token
    self.token = SecureRandom.base58(128)
  end
end
