# frozen_string_literal: true

FactoryBot.define do
  factory :domain_merchant_transaction, class: 'Domain::Merchant::Transaction' do
    uuid { SecureRandom.uuid }
    amount { BigDecimal('1000') }
    status { :processed }
  end
end
