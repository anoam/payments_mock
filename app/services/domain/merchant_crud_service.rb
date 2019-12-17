# frozen_string_literal: true

module Domain::MerchantCrudService
  class << self
    # Creates a domain merchant with given info
    # @param merchant_info [#email, #description, #name]
    # @return result
    def create(merchant_info)
      build_info_result = Domain::Merchant::Info.build(
        merchant_info.email,
        merchant_info.name,
        merchant_info.description
      )
      return build_info_result unless build_info_result.success?
      # Uniqueness isn't a problem of entity. It is a problem of the process
      return Result.failure(%i[email_already_used]) if Domain::Merchant.with_email(merchant_info.email).exists?

      merchant = Domain::Merchant.build(build_info_result.payload)
      merchant.save!

      Result.success(merchant)
    end

    # Updates a domain merchant with given info
    # @param id [Integer]
    # @param merchant_info [#email, #description, #name]
    # @return result
    def update(id, merchant_info)
      merchant = Domain::Merchant.find(id)

      build_info_result = Domain::Merchant::Info.build(
        merchant_info.email,
        merchant_info.name,
        merchant_info.description
      )

      return build_info_result unless build_info_result.success?
      # Uniqueness isn't a problem of entity. It is a problem of the process
      return Result.failure(%i[email_already_used]) if Domain::Merchant.with_email(merchant_info.email).exclude(merchant).exists?

      merchant.info = build_info_result.payload
      merchant.save!

      Result.success(merchant)
    end
  end
end
