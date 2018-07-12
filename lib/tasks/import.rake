namespace :import do
  desc "Give the path of the files to import in this order: payers, paid invoices and opened invoices"
  task :all, [:payer_path, :paid_path, :opened_path] => [:payers, :paid_invoices, :opened_invoices] do |t, args|
    puts "Importing all"
  end

  desc "Given the path of a excel spreadsheet exported from Smart it will import payers "
  task :payers, [:payer_path, :paid_path, :opened_path] => :environment do |t, args|
    path = args.payer_path
    ExtractDataFromXlsx.new.payers_importation(path)
  end

  desc "Given the path of a excel spreadsheet exported from Smart it will import paid invoices "
  task :paid_invoices, [:payer_path, :paid_path, :opened_path] => :environment do |t, args|
    path = args.paid_path
    ExtractDataFromXlsx.new.paid_invoices_importation(path)
  end

  desc "Given the path of a excel spreadsheet exported from Smart it will import opened invoices "
  task :opened_invoices, [:payer_path, :paid_path, :opened_path] => :environment do |t, args|
    path = args.opened_path
    ExtractDataFromXlsx.new.opened_invoices_importation(path)
  end
end
