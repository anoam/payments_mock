# frozen_string_literal: true

FactoryBot.define do
  factory :user_management_merchant, class: 'UserManagement::Merchant' do
    sequence(:email) { |n| "merchant_#{n}@email.email" }
    encrypted_password { '$2a$12$Aj1O7tpeVjINuFooSjoa7.UhYSZyEm6S/SDm2FSMxqekNV22GcVdy' } # 123

    domain_merchant
  end
end
