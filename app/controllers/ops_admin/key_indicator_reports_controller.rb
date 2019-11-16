module OpsAdmin
  class KeyIndicatorReportsController < OpsAdmin::BaseController
    def index
      @key_indicator_reports = Risk::KeyIndicatorReport.where(key_indicator_report_request_id: params[:request_id])
                                                       .paginate(page: params[:page], per_page: 10)
    end

    def create
      input_data = {
        cnpjs: params.dig(:risk_key_indicator_report, :input_data)&.split(','),
        operation_id: params[:operation_id],
        kind: params[:kind]
      }

      respond_to do |format|
        begin
          @key_indicator_report_request = Risk::Service::KeyIndicatorReportRequest.call(input_data)

          format.html { redirect_to ops_admin_key_indicator_reports_path(request_id: @key_indicator_report_request) }
        rescue Exception => e
          @key_indicator_report = Risk::KeyIndicatorReport.new
          @key_indicator_report.errors.add(:input_data, e.message)
          @key_indicator_report.input_data = input_data[:cnpjs]&.join(',')
          format.html { render :new, flash: e.message }
        end
      end
    end

    def show
      @key_indicator_report = Risk::KeyIndicatorReport.find(params[:id])
      @presenter = Risk::Presenter::KeyIndicatorReport.new(@key_indicator_report)
      @cnpj = params[:cnpj]

      respond_to do |format|
        format.html
        format.json { render json: { processed: @key_indicator_report.processed }}
      end
    end

    def new
      @key_indicator_report = Risk::KeyIndicatorReport.new
    end
  end
end
