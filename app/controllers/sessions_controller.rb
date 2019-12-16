# frozen_string_literal: true

class SessionsController < ApplicationController
  # Only renders a sign ins form
  def signin_form
    @form = SignInForm.new
  end

  def sign_in
    @form = SignInForm.from_params(params)

    result = auth_service.sign_in(@form.email, @form.password)

    respond_to do |format|
      format.html { html_isgn_in_response(result) }
      format.json { json_sign_in_response(result) }
    end
  end

  private

  def json_sign_in_response(result)
    if result.success?
      render status: :ok, json: {token: result.payload.token}
    else
      render status: :bad_request, json: {error: I18n.t("sessions.errors.#{result.payload}")}
    end
  end

  def html_isgn_in_response(result)
    if result.success?
      session[:current_user_token] = result.payload.token
      if result.payload.is_a?(UserManagement::Merchant)
        redirect_to merchant_space_path
      else
        redirect_to admin_space_path
      end
    else
      render action: :signin_form
    end
  end

  def auth_service
    UserManagement::AuthenticationService
  end
end
