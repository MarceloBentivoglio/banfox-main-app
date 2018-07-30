require 'google/apis/sheets_v4'
require 'googleauth'

# = Spreadsheets BaseService
module Spreadsheets
  class UndefinedSpreadsheetId < StandardError; end
  class UndefinedWorksheetName < StandardError; end
  class RowNotFound < StandardError; end

  class BaseService
    def initialize(app_name, service_auth_json_key, spreadsheet_id, worksheet_name, args={})

      raise UndefinedSpreadsheetId unless spreadsheet_id
      raise UndefinedWorksheetName unless worksheet_name

      # Log
      @log_level = (args[:log_level] || 'INFO').upcase
      @log_dev = args[:log_dev] || STDOUT
      @logger = Logger.new(@log_dev)
      @logger.level = Logger.const_get(@log_level)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{self.class.name} - #{severity} [#{datetime.strftime('%Y-%m-%d %H:%M:%S.%L')}]: #{msg}\n"
      end

      # Sheet params
      @app_name = app_name
      @spreadsheet_id = spreadsheet_id
      @worksheet_name = worksheet_name

      # Connect
      @service_auth_json_key = service_auth_json_key
      @service = get_service
      @authorization = get_authorization
      @service.client_options.application_name = app_name
      @service.authorization = @authorization

      # initialize
      @int_to_a1 = ('A'..'ZZZ').to_a
      @headers = get_headers
      @header_keys = @headers.map{|h| h[:value]}
    end

    def header_row
      1
    end

    def value_input_option
      'USER_ENTERED'
    end

    def int_to_a1(int)
      @int_to_a1[int]
    end

    def get_row(row)
      row = @service.get_spreadsheet_values(
        @spreadsheet_id, "#{@worksheet_name}!#{row}:#{row}", { major_dimension: 'ROWS' }
      ).values.first
      raise RowNotFound if row.nil?
      row.map.with_index{|value, int| { value: value, index: int_to_a1(int) } }
    end

    def get_headers
      get_row(header_row)
    end

    def set_row(row_index, fields)
      headers_to_set = @headers.select{ |h| fields[h[:value]].present? }

      data_to_set = headers_to_set.map do |h|
        value = fields[h[:value]]
        Google::Apis::SheetsV4::ValueRange.new(
          range: "#{@worksheet_name}!#{h[:index]}#{row_index}:#{h[:index]}#{row_index}",
          values: [[value]]
        )
      end

      if (data_to_set.count > 0)
        batch_update_values_request_object = Google::Apis::SheetsV4::BatchUpdateValuesRequest.new(
          data: data_to_set,
          value_input_option: value_input_option,
        )

        res = @service.batch_update_values(@spreadsheet_id, batch_update_values_request_object)

        @logger.error('More than the expected number of cells were updated') if (res.total_updated_cells > headers_to_set.count)
        @logger.error('Less than the expected number of cells were updated') if (res.total_updated_cells < headers_to_set.count)
        @logger.error('More than the expected number of cols were updated') if (res.total_updated_columns > headers_to_set.count)
        @logger.error('Less than the expected number of cols were updated') if (res.total_updated_columns < headers_to_set.count)
        @logger.error('More than 1 row were updated') if (res.total_updated_rows > 1)
        @logger.error('Less than 1 row were updated') if (res.total_updated_rows < 1)
        @logger.error('More than 1 sheets were updated') if (res.total_updated_sheets > 1)
        @logger.error('Less than 1 sheets were updated') if (res.total_updated_sheets < 1)

        return res
      end
    end

    def set_rows(first_row_index, fields)
      headers_to_set = @headers.select{ |h| fields.first[h[:value]].present? }

      data_to_set = fields.each_with_index.map do |field, i|
        headers_to_set.map do |h|
          value = field[h[:value]]
          row_index = first_row_index + i
          Google::Apis::SheetsV4::ValueRange.new(
            range: "#{@worksheet_name}!#{h[:index]}#{row_index}:#{h[:index]}#{row_index}",
            values: [[value]]
          )
        end
      end.flatten(1)

      if (data_to_set.count > 0)
        batch_update_values_request_object = Google::Apis::SheetsV4::BatchUpdateValuesRequest.new(
          data: data_to_set,
          value_input_option: value_input_option,
        )

        res = @service.batch_update_values(@spreadsheet_id, batch_update_values_request_object)

        cells_to_set = headers_to_set.count * fields.count
        rows_to_set = fields.count
        @logger.error('More than the expected number of cells were updated') if (res.total_updated_cells > cells_to_set)
        @logger.error('Less than the expected number of cells were updated') if (res.total_updated_cells < cells_to_set)
        @logger.error('More than the expected number of cols were updated') if (res.total_updated_columns > headers_to_set.count)
        @logger.error('Less than the expected number of cols were updated') if (res.total_updated_columns < headers_to_set.count)
        @logger.error('More than the expected number of rows were updated') if (res.total_updated_rows > rows_to_set)
        @logger.error('Less than the expected number of rows were updated') if (res.total_updated_rows < rows_to_set)
        @logger.error('More than 1 sheets were updated') if (res.total_updated_sheets > 1)
        @logger.error('Less than 1 sheets were updated') if (res.total_updated_sheets < 1)

        return res
      end
    end

    def to_hash(rows)
      return rows.map{|row| to_hash(row) } if rows.is_a?(Array)
      row = rows
      row[:data].each.reduce({}) do |hash, row_col|
        hash[@headers[row_col[:index]][:value]] = row_col[:value]
        hash
      end
    end

  protected
    def get_authorization
      Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: StringIO.new(@service_auth_json_key),
        scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
      )
    end

    def get_service
      Google::Apis::SheetsV4::SheetsService.new
    end
  end
end
