# frozen_string_literal: true

# Value object
class Domain::Merchant::Info
  # @!method email
  #   @return [String]
  # @!method name
  #   @return [String]
  # @!method descrition
  #   @return [String]
  attr_reader :email, :name, :description

  # Build an object using given params
  # @param email [String]
  # @param name [String]
  # @param description [String]
  # @return Result
  def self.build(email, name, description)
    errors = []
    errors << :invalid_email unless URI::MailTo::EMAIL_REGEXP.match?(email)
    errors << :invalid_name if name.blank?

    if errors.any?
      Result.failure(errors)
    else
      Result.success(new(email, name, description))
    end
  end

  # @param email [String]
  # @param name [String]
  # @param description [String]
  def initialize(email, name, description)
    @email = email
    @name = name
    @description = description
  end
end
