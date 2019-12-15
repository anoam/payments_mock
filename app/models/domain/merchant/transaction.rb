# frozen_string_literal: true

# Implements behavior of merchants' transaction.
# @note It is a part of the Merchant aggregate, that's why it is nested.
class Domain::Merchant::Transaction < ApplicationRecord
  enum status: {processed: 0, error: 1}

end
