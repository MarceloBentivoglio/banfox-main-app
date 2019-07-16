# == Schema Information
#
# Table name: report_requests
#
#  id                :bigint           not null, primary key
#  cnpj              :string
#  user_id           :bigint
#  company_report_id :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ReportRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
