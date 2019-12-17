# frozen_string_literal: true

require 'rails_helper'
require 'models/domain/shared_examples'

RSpec.describe AdminSpace::MerchantsController::MerchantInfo do
  it_behaves_like('merchant_info') { let(:candidate) { described_class.new(name: 'The merchant', email: 'foo@bar.baz') } }
end
