require 'test_helper'
require 'rake'
require 'nokogiri'

class NfeKeyTest < ActiveSupport::TestCase

  def setup
    using_shared_operation
    Mvpinvest::Application.load_tasks
  end

  test ".add_nfe_key_to_invoices update old invoices adding their respectives nfe_key" do
    @invoice_1.nfe_key = nil
    @invoice_1.document.attach(io: File.open("#{Rails.root}/test/fixtures/files/notaDeTeste.xml"), filename: "notaDeTeste.xml")
    Invoice.stubs(:all).returns([@invoice_1])
    Rake::Task["nfe_key:add_nfe_key_to_invoices"].invoke
    assert_equal @invoice_1.nfe_key, "43190216532989000114550010000009671205396149"
  end
end
