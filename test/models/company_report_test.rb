# == Schema Information
#
# Table name: company_reports
#
#  id         :bigint           not null, primary key
#  cnpj       :string
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CompanyReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
