# frozen_string_literal: true

require 'rails_helper'
require_relative 'shared_examples'

RSpec.describe Domain::Merchant, type: :model do
  describe '#accept_payment' do
    subject(:merchant) do
      described_class.new(email: 'test@test.test', transaction_sum: BigDecimal('100'), transactions: [previous_transaction])
    end

    let(:amount) { BigDecimal('1000.00') }
    let(:processed) { true }
    let(:base_transaction_uuid) { '0a2a5b4e-076a-45e4-b5fb-6da90ea76d4e' }
    let(:payment_info) { double(amount: amount, processed?: processed, base_transaction_uuid: base_transaction_uuid) }
    let(:previous_transaction) { build(:domain_merchant_transaction, uuid: '0a2a5b4e-076a-45e4-b5fb-6da90ea76d4e', amount: BigDecimal('100')) }

    # Ensure the contract
    it_behaves_like('payment_info') { let(:candidate) { payment_info } }

    it 'creates a transaction' do
      merchant.accept_payment(payment_info)

      expect(merchant.transactions).to include(
        satisfy { |transaction| transaction.amount == BigDecimal('1000.00') && transaction.processed? && transaction.base == previous_transaction }
      )
    end

    it 'updates amount sum' do
      expect { merchant.accept_payment(payment_info) }.to change(merchant, :transaction_sum).to(BigDecimal('1100'))
    end

    it 'returns success' do
      expect(merchant.accept_payment(payment_info)).to be_success
    end

    context 'when amount is negative' do
      let(:amount) { BigDecimal('-1') }

      it 'returns failure' do
        expect(merchant.accept_payment(payment_info)).not_to be_success
      end

      it 'returns failure code' do
        expect(merchant.accept_payment(payment_info).payload).to include(:bad_amount)
      end

      it "doesn't affect transactions" do
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transactions)
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transaction_sum)
      end
    end

    context 'when amount is blank' do
      let(:amount) { nil }

      it 'returns failure' do
        expect(merchant.accept_payment(payment_info)).not_to be_success
      end

      it 'returns failure code' do
        expect(merchant.accept_payment(payment_info).payload).to include(:bad_amount)
      end

      it "doesn't affect transactions" do
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transactions)
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transaction_sum)
      end
    end

    context 'when amount is of inappropriate type' do
      let(:amount) { '1000.00' }

      it 'returns failure' do
        expect(merchant.accept_payment(payment_info)).not_to be_success
      end

      it 'returns failure code' do
        expect(merchant.accept_payment(payment_info).payload).to include(:bad_amount)
      end

      it "doesn't affect transactions" do
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transactions)
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transaction_sum)
      end
    end

    context "when the payment hasn't been processed" do
      let(:processed) { false }

      it 'creates a transaction' do
        merchant.accept_payment(payment_info)

        expect(merchant.transactions).to include(
          satisfy { |transaction| transaction.amount == BigDecimal('1000.00') && !transaction.processed? && transaction.base == previous_transaction }
        )
      end

      it 'updates amount sum' do
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transaction_sum)
      end

      it 'returns success' do
        expect(merchant.accept_payment(payment_info)).to be_success
      end

      it "doesn't affect transactions" do
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transactions)
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transaction_sum)
      end
    end

    context "when base transaction uuid isn't provided" do
      let(:base_transaction_uuid) { nil }

      it 'creates a transaction' do
        merchant.accept_payment(payment_info)

        expect(merchant.transactions).to include(
          satisfy { |transaction| transaction.amount == BigDecimal('1000.00') && transaction.processed? && transaction.base.nil? }
        )
      end

      it 'updates amount sum' do
        expect { merchant.accept_payment(payment_info) }.to change(merchant, :transaction_sum).to(BigDecimal('1100.00'))
      end

      it 'returns success' do
        expect(merchant.accept_payment(payment_info)).to be_success
      end
    end

    context "when base transaction doesn't exist" do
      let(:base_transaction_uuid) { 'unknown-uuid' }

      it 'returns failure' do
        expect(merchant.accept_payment(payment_info)).not_to be_success
      end

      it 'returns failure code' do
        expect(merchant.accept_payment(payment_info).payload).to include(:bad_base_transaction_uuid)
      end

      it "doesn't affect transactions" do
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transactions)
        expect { merchant.accept_payment(payment_info) }.not_to change(merchant, :transaction_sum)
      end
    end
  end

  describe '#remove_outdated_payments', time_travel: Time.utc(2019, 12, 16, 12) do
    subject(:merchant) do
      described_class.create(
        email: 'test@test.test',
        transaction_sum: BigDecimal('0'),
        transactions: [outdated_transaction, relevant_transaction]
      )
    end

    let(:outdated_transaction) { build(:domain_merchant_transaction, created_at: Time.utc(2019, 12, 16, 10, 59)) }
    let(:relevant_transaction) { build(:domain_merchant_transaction, created_at: Time.utc(2019, 12, 16, 11, 1)) }

    it 'revmoves outdated transactions' do
      merchant.remove_outdated_payments

      expect(merchant.transactions).to include(relevant_transaction)
      expect(merchant.transactions).not_to include(outdated_transaction)
    end
  end
end
