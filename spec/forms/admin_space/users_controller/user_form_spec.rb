# frozen_string_literal: true

require 'rails_helper'
require 'services/user_management/shared_examples'

RSpec.describe AdminSpace::UsersController::UserForm do
  it_behaves_like('user_info') { let(:candidate) { described_class.new } }
end
