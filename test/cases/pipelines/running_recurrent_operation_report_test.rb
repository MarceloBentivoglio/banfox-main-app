require 'test_helper'

class RunningRecurrentOperationReportTest < ActiveSupport::TestCase
  setup do
    Risk::Fetcher::Serasa.any_instance
                         .stubs(:call)
    Risk::Fetcher::Serasa.any_instance
                         .stubs(:data)
                         .returns([biort_data])
  end

  test 'run all referees with recurrent_operation but ends up with error because it has no historic data' do
    params = {
      risk_key_indicator_report: {
        input_data: '08588244000149'
      },
      kind: 'recurrent_operation'
    }
  end

  def biort_data
    @biort_data ||= File.new("#{Rails.root}/test/support/files/20190814_BIORT.txt", 'r').read
  end
end
