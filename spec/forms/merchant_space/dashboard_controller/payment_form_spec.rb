# frozen_string_literal: true

require 'rails_helper'
require 'models/domain/shared_examples'
RSpec.describe MerchantSpace::DashboardController::PaymentForm do
  describe '.from_params' do
    it 'builds an instance' do
      expect(described_class.from_params(amount: 100.10, processed: true, base_transaction: 'some-uuid'))
        .to(satisfy { |form| form.amount == BigDecimal('100.10') && form.processed? && form.base_transaction_uuid == 'some-uuid' })
    end

    it 'ignores invalid amount' do
      expect(described_class.from_params(amount: 'wired_string', processed: true, base_transaction: 'some-uuid'))
        .to(satisfy { |form| form.amount == BigDecimal('0') && form.processed? && form.base_transaction_uuid == 'some-uuid' })
    end
  end

  it_behaves_like('payment_info') { let(:candidate) { described_class.from_params(amount: 100.10, processed: true, base_transaction: 'some-uuid') } }
end
