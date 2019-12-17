# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MerchantSpace::DashboardControllers', type: :request do
  before { create(:user_management_merchant, token: 'tricky-token', domain_merchant: domain_merchant) }

  let!(:domain_merchant) { create(:domain_merchant) }

  describe 'POST /merchant_space/accept_payment' do
    it 'Returns uuid of the new transaction' do
      post merchant_space_accept_payment_path(:json), params: {amount: 100, processed: true}, headers: {'Authorization': 'Bearer tricky-token'}

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('uuid')
    end

    it 'Creates transaction for user' do
      expect { post merchant_space_accept_payment_path(:json), params: {amount: 100, processed: true}, headers: {'Authorization': 'Bearer tricky-token'} }
        .to(change { domain_merchant.reload.transactions.count }.from(0).to(1))
    end

    it 'Requires token' do
      post merchant_space_accept_payment_path(:json), params: {amount: 100, processed: true}

      expect(response).to have_http_status(401)
    end

    it 'Checks for errors' do
      post merchant_space_accept_payment_path(:json), params: {amount: 'bad value'}, headers: {'Authorization': 'Bearer tricky-token'}

      expect(response).to have_http_status(400)

      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include('Invalid amount value')
    end
  end
end
