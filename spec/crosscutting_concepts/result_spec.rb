# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Result do
  describe '.success' do
    it 'builds success' do
      expect(described_class.success).to be_success
    end

    it 'build success with a payload' do
      result = described_class.success(:my_payload)

      expect(result).to be_success
      expect(result.payload).to be(:my_payload)
    end
  end

  describe '.failure' do
    it 'builds failure' do
      expect(described_class.failure).not_to be_success
    end

    it 'build success with a payload' do
      result = described_class.failure(:my_payload)

      expect(result).not_to be_success
      expect(result.payload).to be(:my_payload)
    end
  end
end
