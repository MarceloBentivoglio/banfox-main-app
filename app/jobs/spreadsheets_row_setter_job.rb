class SpreadsheetsRowSetterJob < ApplicationJob
  queue_as :default

  def perform(spreadsheet_id, worksheet_name, row_index, fields)
    Spreadsheets::Service.set_row(spreadsheet_id, worksheet_name, row_index, fields)
  end
end
