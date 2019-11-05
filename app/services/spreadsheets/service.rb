module Spreadsheets
  class Service

    def self.app_name
      @@app_name ||= Rails.application.credentials[:google][:google_spreadsheet_app_name]
    end

    def self.json_key
      @@json_key ||= Rails.application.credentials[:google][:google_spreadsheet_json_key]
    end

    def self.service(spreadsheet_id, worksheet_name)
      @@service ||= {}
      @@service[spreadsheet_id] ||= {}
      @@service[spreadsheet_id][worksheet_name] ||= Spreadsheets::BaseService.new(
        Spreadsheets::Service.app_name, Spreadsheets::Service.json_key, spreadsheet_id, worksheet_name
      )
    end

    def self.set_row(spreadsheet_id, worksheet_name, row_index, fields)
      Spreadsheets::Service.service(spreadsheet_id, worksheet_name).set_row(row_index, fields)
    end

    def self.set_rows(spreadsheet_id, worksheet_name, first_row_index, fields)
      Spreadsheets::Service.service(spreadsheet_id, worksheet_name).set_rows(first_row_index, fields)
    end
  end
end
