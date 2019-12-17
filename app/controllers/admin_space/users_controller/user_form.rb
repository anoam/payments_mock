# frozen_string_literal: true

# DTO for application users
class AdminSpace::UsersController::UserForm
  # @param params [Hash]
  def initialize(params = {})
    @params = params
  end

  # @return [String]
  def password
    @params[:password]
  end

  # @return [String]
  def email
    @params[:email]
  end
end
