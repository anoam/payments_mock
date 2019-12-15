# frozen_string_literal: true

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers

  config.around :each, time_travel: ->(value) { value } do |example|
    time = example.metadata[:time_travel]
    travel_to(time) { example.run }
  end
end
