# frozen_string_literal: true

class UserManagement::Merchant < UserManagement::User
  belongs_to :domain_merchant, class_name: 'Domain::Merchant'

  def self.build(email, password, domain_merchant)
    return Result.failure(%i[invalid_merchant]) unless domain_merchant

    result = super(email, password)
    result.payload.domain_merchant = domain_merchant if result.success

    result
  end
end
