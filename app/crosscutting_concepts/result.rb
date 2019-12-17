# frozen_string_literal: true

# Implements a result-object to encapsulate a result of an operation
class Result
  # @!method success
  #   @return [Boolean]
  # @!method payload
  #   @return [Object]
  attr_reader :success, :payload
  # @!method success?
  #   @return [Boolean]
  alias success? success

  # @param success [Boolean] weather the result is successful or not
  # @param payload [Object] some related objects
  def initialize(success, payload)
    @success = success
    @payload = payload
  end

  # Builds a result which is meant to be a success
  # @param payload [Object] some related objects
  def self.success(payload = nil)
    new(true, payload)
  end

  # Builds a result which is meant to be a failure
  # @param payload [Object] some related objects
  def self.failure(payload = nil)
    new(false, payload)
  end
end
