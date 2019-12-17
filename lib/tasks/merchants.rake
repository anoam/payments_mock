# frozen_string_literal: true

namespace :merchants do
  desc 'Import merchants from scv'
  task :import, %i[file] => :environment do |_task, args|
    require_relative 'csv_merchant_info'

    File.foreach(args.file) do |line|
      form = CsvMerchantInfo.new(line)

      result = Domain::MerchantCrudService.create(form)
      raise "Unable to process line the `#{line}`" unless result.success?

      UserManagement::ManageUserService.create_merchant(result.payload)
    end
  end
end
