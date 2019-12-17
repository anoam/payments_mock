# frozen_string_literal: true

class CsvMerchantInfo
  attr_reader :name, :email, :description
  def initialize(string)
    @name, @email, @description = string.split(';', 3).map(&:strip)
  end
end
