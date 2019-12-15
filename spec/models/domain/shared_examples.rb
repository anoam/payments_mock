# frozen_string_literal: true

RSpec.shared_examples 'payment_info' do
  it { expect(candidate).to respond_to(:amount) }
  it { expect(candidate).to respond_to(:processed?) }
  it { expect(candidate).to respond_to(:base_transaction_uuid) }
end
