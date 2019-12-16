# frozen_string_literal: true

class SessionsController::SignInForm
  # @!method email
  #   @return [String]
  # @!method password
  #   @return [String]
  attr_reader :email, :password

  # Creates an object using params
  # @param params [ActionController::Parameters]
  def self.from_params(params)
    email = params.fetch(:email)
    password = params.fetch(:password)

    new(email, password)
  end

  # @param email [String]
  # @param password [String]
  def initialize(email = '', password = '')
    @email = email
    @password = password
  end
end
