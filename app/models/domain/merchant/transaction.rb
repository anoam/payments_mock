# frozen_string_literal: true

# Implements behavior of merchants' transaction.
# @note It is a part of the Merchant aggregate, that's why it is nested.
class Domain::Merchant::Transaction < ApplicationRecord
  enum status: {processed: 0, error: 1}

  belongs_to :base, optional: true, class_name: 'Domain::Merchant::Transaction', foreign_key: :base_transaction_id # rubocop:disable Rails/InverseOf

  # Factory-method
  # @param info [#amount, #processed?] transaction parameters
  # @param base [Domain::Merchant::Transaction] base transaction
  # @return [Result]
  def self.build(info, base)
    return Result.failure(%i[bad_amount]) unless info.amount.is_a?(BigDecimal)
    return Result.failure(%i[bad_amount]) unless info.amount.positive?

    Result.success(
      new(
        amount: info.amount,
        status: info.processed? ? :processed : :error,
        uuid: SecureRandom.uuid,
        base: base
      )
    )
  end
end
