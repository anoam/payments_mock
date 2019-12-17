# frozen_string_literal: true

scheduler = Rufus::Scheduler.new

scheduler.every '10m' do
  Domain::Merchant.find_each do |merchant|
    merchant.remove_outdated_payments
    merchant.save
  end
end
