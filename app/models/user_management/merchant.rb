# frozen_string_literal: true

class UserManagement::Merchant < UserManagement::User
  belongs_to :domain_merchant, class_name: 'Domain::Merchant'
end
