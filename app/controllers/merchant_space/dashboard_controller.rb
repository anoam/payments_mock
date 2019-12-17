# frozen_string_literal: true

class MerchantSpace::DashboardController < ApplicationController
  before_action :authorize_with_session!, only: :index
  skip_forgery_protection only: :accept_payment
  before_action :authorize_with_http_token!, only: :accept_payment

  # a list of transactions
  def index; end

  # add a payment for
  def accept_payment
    payment_info = PaymentForm.from_params(params)

    result = @domain_merchant.accept_payment(payment_info)

    if result.success?
      @domain_merchant.save!

      render status: :ok, json: {uuid: result.payload.uuid}
    else
      render status: :bad_request, json: {errors: result.payload.map { |code| I18n.t("merchant_space.dasboard.errors.#{code}") }}
    end
  end

  private

  def authorize_with_session!
    authenticate_with_token!(session[:current_user_token])

    redirect_to root_path unless @current_user
  end

  def authorize_with_http_token!
    authenticate_with_http_token do |token, _options|
      authenticate_with_token!(token)
    end

    render status: :unauthorized, json: {error: 'Unable to authorize'} unless @current_user
  end

  def authenticate_with_token!(token)
    result = UserManagement::AuthenticationService.authenticate_by_token(token)

    return unless result.success?
    return unless result.payload.is_a?(UserManagement::Merchant)

    @current_user = result.payload
    @domain_merchant = @current_user.domain_merchant
  end
end
