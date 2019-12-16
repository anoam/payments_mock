# frozen_string_literal: true

# Base class for users of the Application
class UserManagement::User < ApplicationRecord
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
end
