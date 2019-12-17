# frozen_string_literal: true

require 'rails_helper'
require 'models/domain/shared_examples'

RSpec.describe Domain::MerchantCrudService do
  let(:info) { double(email: email, name: name, description: description) }
  let(:email) { 'merchant@test.test' }
  let(:name) { 'The merchant' }
  let(:description) { 'Very cool one' }

  it_behaves_like('merchant_info') { let(:candidate) { info } }

  describe '.create' do
    it 'creates new merchant' do
      result = described_class.create(info)

      expect(result).to be_success
      expect(result.payload).to(satisfy do |merchant|
        merchant.name == 'The merchant' && merchant.description == description && merchant.transaction_sum == BigDecimal('0') && merchant.email == 'merchant@test.test'
      end)
    end

    context 'when email already has been used' do
      before { create(:domain_merchant, email: 'merchant@test.test') }

      it 'returns failure' do
        result = described_class.create(info)

        expect(result).not_to be_success
        expect(result.payload).to include(:email_already_used)
      end
    end

    context 'when email is invalid' do
      let(:email) { 'something' }

      it 'returns failure' do
        result = described_class.create(info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_email)
      end
    end

    context 'when email is missed' do
      let(:email) { nil }

      it 'returns failure' do
        result = described_class.create(info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_email)
      end
    end

    context 'when name is missed' do
      let(:name) { nil }

      it 'returns failure' do
        result = described_class.create(info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_name)
      end
    end
  end

  describe '.update' do
    let(:merchant) { create(:domain_merchant) }
    let(:id) { merchant.id }

    it 'updates the merchant' do
      result = described_class.update(id, info)

      expect(result).to be_success
      expect(merchant.reload).to(satisfy do |merchant|
        merchant.name == 'The merchant' && merchant.description == description && merchant.email == 'merchant@test.test'
      end)
    end

    context 'when email already has been used' do
      before { create(:domain_merchant, email: 'merchant@test.test') }

      it 'returns failure' do
        result = described_class.update(id, info)

        expect(result).not_to be_success
        expect(result.payload).to include(:email_already_used)
      end
    end

    context 'when email is invalid' do
      let(:email) { 'something' }

      it 'returns failure' do
        result = described_class.update(id, info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_email)
      end
    end

    context 'when email is missed' do
      let(:email) { nil }

      it 'returns failure' do
        result = described_class.update(id, info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_email)
      end
    end

    context 'when name is missed' do
      let(:name) { nil }

      it 'returns failure' do
        result = described_class.update(id, info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_name)
      end
    end
  end
end
