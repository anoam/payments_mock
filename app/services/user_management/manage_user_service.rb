# frozen_string_literal: true

class UserManagement::ManageUserService
  class << self
    # Tries to create new admin
    # @param user_info [#email, #password]
    # @return [Result]
    def create_admin(user_info)
      errors = validate_attributes(user_info.email, user_info.password)
      return Result.failure(errors) if errors.any?

      Result.success(UserManagement::Admin.create(email: user_info.email, password: user_info.password))
    end

    # Tries to create a user for the given domain merchant
    # @param domain_merchant [Domain::Merchant]
    # @return [Result]
    def create_merchant(domain_merchant)
      email = domain_merchant.email
      password = domain_merchant.email # just for demonstration

      errors = validate_attributes(email, password)

      return Result.failure(errors) if errors.any?

      Result.success(UserManagement::Merchant.create!(email: email, password: password, domain_merchant: domain_merchant))
    end

    # Tries to update the user's email and password
    # @param user_info [String]
    # @return Result
    def update(id, user_info)
      user = UserManagement::User.find(id)
      return Result.failure(%i[not_found]) unless user

      errors = validate_attributes(user_info.email, user_info.password, user)
      return Result.failure(errors) if errors.any?

      user.update!(email: user_info.email, password: user_info.password)

      Result.success(user)
    end

    private

    def set_data(user, data)
      user.attributes = data
      collect_error_codes(user)
    end

    def collect_error_codes(user)
      user.errors.keys.map { |key| :"invalid_#{key}" }
    end

    def email_used?(email)
      User.find_by_email(email).present?
    end

    def validate_attributes(email, password, for_user = nil)
      user_with_email = UserManagement::User.find_by_email(email)

      [].tap do |errors|
        errors << :invalid_email unless UserManagement::User.valid_email?(email)
        errors << :invalid_password unless UserManagement::User.valid_password?(password)
        errors << :email_already_used if user_with_email.present? && user_with_email != for_user
      end
    end
  end
end
