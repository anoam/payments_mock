# frozen_string_literal: true

RSpec.shared_examples 'user_info' do
  it { expect(candidate).to respond_to(:email) }
  it { expect(candidate).to respond_to(:password) }
end
