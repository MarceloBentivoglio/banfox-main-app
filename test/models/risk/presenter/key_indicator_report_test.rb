require 'test_helper'

class Risk::Presenter::KeyIndicatorReportTest < ActiveSupport::TestCase
  test 'returns a gray_flag conclusion' do
    using_shared_operation
    key_indicator_report = FactoryBot.create(:key_indicator_report,
                                             :with_indicators,
                                             :with_evidences,
                                             operation_id: @operation.id)

    presenter = Risk::Presenter::KeyIndicatorReport.new(key_indicator_report)

    expected = [
      {
        cnpj: "07526557000100",
        name_with_cnpj: "Company Name - 07.526.557/0001-00",
        flags: {
          gray: 1,
          green: 1,
          yellow: 0,
          red: 0
        }
      }
    ]

    assert_equal expected, presenter.conclusions
  end
end
