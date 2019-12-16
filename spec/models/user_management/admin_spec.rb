# frozen_string_literal: true

require 'rails_helper'
require_relative 'user_shared_examples'

RSpec.describe UserManagement::Admin, type: :model do
  it_behaves_like('has password') { let(:user) { described_class.new } }
  it_behaves_like('has token') { let(:user) { described_class.new } }
end
