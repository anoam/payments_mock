# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserManagement::AuthenticationService do
  subject(:service) { described_class }

  describe '.sign_in' do
    context 'when user is admin' do
      let!(:admin) { create(:user_management_admin, email: 'admin@test.test') }

      context 'when credentials are valid' do
        it 'returns success' do
          result = service.sign_in('admin@test.test', '123')

          expect(result).to be_success
          expect(result.payload).to eql(admin)
        end

        it "updates admin's token" do
          expect { service.sign_in('admin@test.test', '123') }.to(change { admin.reload.token })
        end
      end

      context "when admin doesn't exist" do
        it 'returns failure' do
          result = service.sign_in('unknown@test.test', '123')

          expect(result).not_to be_success
          expect(result.payload).to be(:invalid_credentials)
        end
      end

      context 'when password is invalid' do
        it 'returns failure' do
          result = service.sign_in('admin@test.test', 'wrong_password')

          expect(result).not_to be_success
          expect(result.payload).to be(:invalid_credentials)
        end
      end
    end

    context 'when user is merchant' do
      let!(:merchant) { create(:user_management_merchant, email: 'merchant@test.test') }

      context 'when credentials are valid' do
        it 'returns success' do
          result = service.sign_in('merchant@test.test', '123')

          expect(result).to be_success
          expect(result.payload).to eql(merchant)
        end

        it "updates merchant's token" do
          expect { service.sign_in('merchant@test.test', '123') }.to(change { merchant.reload.token })
        end
      end

      context "when merchant doesn't exist" do
        it 'returns failure' do
          result = service.sign_in('unknown@test.test', '123')

          expect(result).not_to be_success
          expect(result.payload).to be(:invalid_credentials)
        end
      end

      context 'when password is invalid' do
        it 'returns failure' do
          result = service.sign_in('merchant@test.test', 'wrong_password')

          expect(result).not_to be_success
          expect(result.payload).to be(:invalid_credentials)
        end
      end
    end
  end

  describe '.authenticate_by_token' do
    context 'when user is admin' do
      let!(:admin) { create(:user_management_admin, token: 'auth-token') }

      context 'when token is valid' do
        it 'returns success' do
          result = service.authenticate_by_token('auth-token')

          expect(result).to be_succes
          expect(result.payload).to eql(admin)
        end
      end

      context 'when token is invalid' do
        it 'returns success' do
          result = service.authenticate_by_token('bad-token')

          expect(result).not_to be_success
          expect(result.payload).to be(:invalid_token)
        end
      end
    end

    context 'when user is merchant' do
      let!(:merchant) { create(:user_management_merchant, token: 'auth-token') }

      context 'when token is valid' do
        it 'returns success' do
          result = service.authenticate_by_token('auth-token')

          expect(result).to be_success
          expect(result.payload).to eql(merchant)
        end
      end

      context 'when token is invalid' do
        it 'returns success' do
          result = service.authenticate_by_token('bad-token')

          expect(result).not_to be_success
          expect(result.payload).to be(:invalid_token)
        end
      end
    end
  end
end
