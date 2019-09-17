class KeyIndicatorReportJob < ApplicationJob
  queue_as :default

  def perform(key_indicator_report_id)
    key_indicator_report = Risk::KeyIndicatorReport.find(key_indicator_report_id)

    Risk::Service::KeyIndicatorReport.process(key_indicator_report)
    key_indicator_report.update(processed: true)
  end
end
