# frozen_string_literal: true

# Implements a behaviour of the merchant as a part of domain
class Domain::Merchant < ApplicationRecord
  enum status: {active: 0, inactive: 1}

  has_many :transactions, class_name: 'Domain::Merchant::Transaction', dependent: :delete_all

  # Creates a transaction according to given information
  # @param payment_info [#amount, #processed?, #base_transaction_uuid] base payment data
  # @return [Result]
  def accept_payment(payment_info)
    base_transaction = nil

    if payment_info.base_transaction_uuid
      base_transaction = transactions.find { |transaction| transaction.uuid == payment_info.base_transaction_uuid }
      return Result.failure(%i[bad_base_transaction_uuid]) unless base_transaction
    end

    result = Domain::Merchant::Transaction.build(payment_info, base_transaction)

    if result.success?
      transactions << result.payload
      update_transaction_sum
    end

    result
  end

  # Removes all payments older than 1 hour
  def remove_outdated_payments
    self.transactions = transactions.find_all { |transaction| transaction.created_at > 1.hour.ago }
  end

  private

  def update_transaction_sum
    self.transaction_sum = transactions.filter(&:processed?).sum(&:amount)
  end
end
