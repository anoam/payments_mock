# frozen_string_literal: true

# DTO for merchant's CRUD
class AdminSpace::MerchantsController::MerchantInfo
  # @param merchant [Domain::Merchant]
  def self.for_merchant(merchant)
    new(merchant.slice(:email, :description, :name))
  end

  # @param params [Hash]
  def initialize(params = {})
    @params = params
  end

  # @return [String]
  def email
    @params[:email]
  end

  # @return [String]
  def name
    @params[:name]
  end

  # @return [String]
  def description
    @params[:description]
  end
end
