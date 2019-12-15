# frozen_string_literal: true

# Base class for AR models
# @abstract
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
