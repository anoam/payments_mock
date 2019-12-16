# frozen_string_literal: true

# Base class for users of the Application
# @abstract
class UserManagement::User < ApplicationRecord
  # Tries to find a user with given email
  # @param email [String]
  def self.find_by_email(email)
    find_by(email: email)
  end

  # Tries to find a user with given token
  # @param token [String]
  def self.find_by_token(token)
    find_by(token: token)
  end

  # Sets new password for the user
  # @param password [String]
  def password=(password)
    self.encrypted_password = BCrypt::Password.create(password)
  end

  # Checks weather the the given password match stored one
  # @param password [String]
  def correct_password?(password)
    BCrypt::Password.new(encrypted_password) == password
  end

  # Update authentication token
  def regenerate_token
    self.token = SecureRandom::base58(128)
  end
end
