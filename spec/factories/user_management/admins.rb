# frozen_string_literal: true

FactoryBot.define do
  factory :user_management_admin, class: 'UserManagement::Admin' do
    sequence(:email) { |n| "admin_#{n}@email.email" }
    encrypted_password { '$2a$12$Aj1O7tpeVjINuFooSjoa7.UhYSZyEm6S/SDm2FSMxqekNV22GcVdy' } # 123
  end
end
