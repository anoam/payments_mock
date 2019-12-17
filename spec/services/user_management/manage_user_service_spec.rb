# frozen_string_literal: true

require 'rails_helper'
require_relative 'shared_examples'

RSpec.describe UserManagement::ManageUserService do
  subject(:service) { described_class }

  let(:user_info) { double(email: email, password: password) }
  let(:email) { 'test@test.test' }
  let(:password) { 'qwerty' }

  it_behaves_like('user_info') { let(:candidate) { user_info } }

  describe '.create_admin' do
    context 'when parameters are valid' do
      it 'creates an admin' do
        expect { service.create_admin(user_info) }.to(change { UserManagement::Admin.count }.by(1))
      end

      it 'returns success' do
        result = service.create_admin(user_info)

        expect(result).to be_success
        expect(result.payload).to(satisfy { |admin| admin.is_a?(UserManagement::Admin) && admin.email == 'test@test.test' && admin.correct_password?('qwerty') })
      end
    end

    context 'when email is invalid' do
      let(:email) { 'invalid' }

      it "doesn't create an admin" do
        expect { service.create_admin(user_info) }.not_to(change { UserManagement::Admin.count })
      end

      it 'returns failure' do
        result = service.create_admin(user_info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_email)
      end
    end

    context 'when password is invalid' do
      let(:password) { nil }

      it "doesn't create an admin" do
        expect { service.create_admin(user_info) }.not_to(change { UserManagement::Admin.count })
      end

      it 'returns failure' do
        result = service.create_admin(user_info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_password)
      end
    end

    context 'when email isalready used' do
      before { create(:user_management_admin, email: 'test@test.test') }

      it "doesn't create an admin" do
        expect { service.create_admin(user_info) }.not_to(change { UserManagement::Admin.count })
      end

      it 'returns failure' do
        result = service.create_admin(user_info)

        expect(result).not_to be_success
        expect(result.payload).to include(:email_already_used)
      end
    end
  end

  describe '.update' do
    let(:user) { create(:user_management_merchant) }

    context 'when parameters are valid' do
      it "updates user's email" do
        expect { service.update(user.id, user_info) }.to(change { user.reload.email }.to('test@test.test'))
      end

      it "updates user's password" do
        expect { service.update(user.id, user_info) }.to(change { user.reload.correct_password?('qwerty') }.from(false).to(true))
      end

      it 'returns success' do
        result = service.update(user.id, user_info)

        expect(result).to be_success
        expect(result.payload).to eq(user)
      end
    end

    context 'when email is invalid' do
      let(:email) { 'invalid' }

      it "doesn't update user's email" do
        expect { service.update(user.id, user_info) }.not_to(change { user.reload.email })
      end

      it "doesn't update user's password" do
        expect { service.update(user.id, user_info) }.not_to(change { user.reload.encrypted_password })
      end

      it 'returns failure' do
        result = service.update(user.id, user_info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_email)
      end
    end

    context 'when password is invalid' do
      let(:password) { nil }

      it "doesn't update user's email" do
        expect { service.update(user.id, user_info) }.not_to(change { user.reload.email })
      end

      it "doesn't update user's password" do
        expect { service.update(user.id, user_info) }.not_to(change { user.reload.encrypted_password })
      end

      it 'returns failure' do
        result = service.update(user.id, user_info)

        expect(result).not_to be_success
        expect(result.payload).to include(:invalid_password)
      end
    end

    context 'when email is already used' do
      before { create(:user_management_admin, email: 'test@test.test') }

      it "doesn't update user's email" do
        expect { service.update(user.id, user_info) }.not_to(change { user.reload.email })
      end

      it "doesn't update user's password" do
        expect { service.update(user.id, user_info) }.not_to(change { user.reload.encrypted_password })
      end

      it 'returns failure' do
        result = service.update(user.id, user_info)

        expect(result).not_to be_success
        expect(result.payload).to include(:email_already_used)
      end
    end
  end

  describe '.create_merchant' do
    let(:domain_merchant) { create(:domain_merchant, email: 'domain_merchant@merchant.test') }

    it 'creates a merchant' do
      expect { service.create_merchant(domain_merchant) }.to(change { UserManagement::Merchant.count }.by(1))
    end

    it 'returns success' do
      result = service.create_merchant(domain_merchant)

      expect(result).to be_success
      expect(result.payload).to(satisfy { |admin| admin.is_a?(UserManagement::Merchant) && admin.email == 'domain_merchant@merchant.test' && admin.correct_password?('domain_merchant@merchant.test') })
    end
  end
end
