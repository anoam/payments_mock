# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::Merchant::Info do
  describe '.build' do
    specify do
      expect(described_class.build('email@email.email', 'the name', 'some description'))
        .to(satisfy do |result|
          result.success? && result.payload.email == 'email@email.email' &&
            result.payload.name == 'the name' && result.payload.description == 'some description'
        end)
    end

    specify do
      expect(described_class.build('email@email.email', 'the name', nil))
        .to(satisfy do |result|
          result.success? && result.payload.email == 'email@email.email' &&
            result.payload.name == 'the name' && result.payload.description.nil?
        end)
    end

    specify do
      expect(described_class.build('invalid email', 'the name', 'some dewscription'))
        .to(satisfy { |result| !result.success? && result.payload == %i[invalid_email] })
    end

    specify do
      expect(described_class.build(nil, nil, 'some dewscription'))
        .to(satisfy { |result| !result.success? && result.payload == %i[invalid_email invalid_name] })
    end

    specify do
      expect(described_class.build('email@email.email', nil, 'some dewscription'))
        .to(satisfy { |result| !result.success? && result.payload == %i[invalid_name] })
    end
  end
end
