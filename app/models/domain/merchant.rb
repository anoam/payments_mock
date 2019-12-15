# frozen_string_literal: true

# Implements a behaviour of the merchant as a part of domain
class Domain::Merchant < ApplicationRecord
  enum status: {active: 0, inactive: 1}

end
