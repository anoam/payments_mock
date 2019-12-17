# frozen_string_literal: true

class AdminSpace::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_with_session!

  private

  def authenticate_with_session!
    result = UserManagement::AuthenticationService.authenticate_by_token(session[:current_user_token])

    unless result.success?
      redirect_to root_path
      return
    end

    @current_user = result.payload
    redirect_to root_path unless @current_user.is_a?(UserManagement::Admin)
  end
end