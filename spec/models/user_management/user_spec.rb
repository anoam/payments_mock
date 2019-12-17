# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserManagement::User, type: :model do
  describe '.find_by_email' do
    subject { described_class }

    let!(:merchant) { create(:user_management_merchant, email: 'merchant@test.test') }
    let!(:admin) { create(:user_management_admin, email: 'admin@test.test') }

    it 'finds merchant' do
      expect(subject.find_by_email('merchant@test.test')).to eql(merchant)
    end

    it 'finds admin' do
      expect(subject.find_by_email('admin@test.test')).to eql(admin)
    end

    it 'returns nil for invalid email' do
      expect(subject.find_by_email('invalid@test.test')).to be_nil
    end
  end

  describe '.find_by_token' do
    subject { described_class }

    let!(:merchant) { create(:user_management_merchant, token: 'merchant-token') }
    let!(:admin) { create(:user_management_admin, token: 'admin-token') }

    it 'finds merchant' do
      expect(subject.find_by_token('merchant-token')).to eql(merchant)
    end

    it 'finds admin' do
      expect(subject.find_by_token('admin-token')).to eql(admin)
    end

    it 'returns nil for invalid token' do
      expect(subject.find_by_token('invalid-token')).to be_nil
    end
  end
end
