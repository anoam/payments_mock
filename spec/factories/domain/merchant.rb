# frozen_string_literal: true

FactoryBot.define do
  factory :domain_merchant, class: 'Domain::Merchant' do
    transaction_sum { BigDecimal('100') }
    sequence(:email) { |n| "merchant_#{n}@email.email" }
  end
end
