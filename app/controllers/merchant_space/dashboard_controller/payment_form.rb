# frozen_string_literal: true

# DTO for payments
class MerchantSpace::DashboardController::PaymentForm
  # @!method amount
  #   @return [BigDecimal]
  # @!method processed
  #   @return [Boolean]
  # @!method base_transaction_uuid
  #   @return [String]
  attr_reader :amount, :processed, :base_transaction_uuid
  alias processed? processed

  class << self
    # Creates an object using params
    # @param params [ActionController::Parameters]
    def from_params(params)
      new(
        try_to_parse_decimal(params[:amount]),
        params[:processed],
        params[:base_transaction]
      )
    end

    private

    def try_to_parse_decimal(value)
      BigDecimal(value.to_s)
    rescue ArgumentError
      BigDecimal('0')
    end
  end

  # @param amount [BigDecimal]
  # @param processed [Boolean]
  # @param base_transaction_uuid [String]
  def initialize(amount, processed, base_transaction_uuid)
    @amount = amount
    @processed = processed
    @base_transaction_uuid = base_transaction_uuid
  end
end
