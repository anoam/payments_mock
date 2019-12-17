# frozen_string_literal: true

RSpec.shared_examples 'payment_info' do
  it { expect(candidate).to respond_to(:amount) }
  it { expect(candidate).to respond_to(:processed?) }
  it { expect(candidate).to respond_to(:base_transaction_uuid) }
end

RSpec.shared_examples 'merchant_info' do
  it { expect(candidate).to respond_to(:name) }
  it { expect(candidate).to respond_to(:description) }
  it { expect(candidate).to respond_to(:email) }
end
