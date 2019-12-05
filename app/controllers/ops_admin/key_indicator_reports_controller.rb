module OpsAdmin
  class KeyIndicatorReportsController < OpsAdmin::BaseController
    def authenticate_admin
      return if current_user.admin? || current_user.kir_permission?
      redirect_to root_path
    end

    def index
      @key_indicator_reports = Risk::KeyIndicatorReport.where(key_indicator_report_request_id: params[:request_id])
                                                       .order('created_at DESC')
                                                       .paginate(page: params[:page], per_page: 10)


    end

    def create
      input_data = {
        cnpjs: params.dig(:risk_key_indicator_report, :input_data)&.split(','),
        operation_id: params[:operation_id],
        kind: params[:kind]
      }


      @history = Risk::KeyIndicatorReport.where(requested_by_user_id: current_user.id)
      respond_to do |format|
        begin
          @key_indicator_report_request = Risk::Service::KeyIndicatorReportRequest.call(input_data, current_user)

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
        if current_user.kir_permission?
          format.html { redirect_to root_path }
        else
          format.html
          format.json { render json: { processed: @key_indicator_report.processed }}
        end
      end
    end

    def report
      @key_indicator_report = Risk::KeyIndicatorReport.find(params[:id])
      @presenter = Risk::Presenter::CompanyReport.new(@key_indicator_report)
    end

    def new
      @key_indicator_report = Risk::KeyIndicatorReport.new
      @history = Risk::KeyIndicatorReport.where(requested_by_user_id: current_user.id)
                                         .order('created_at DESC')
    end
  end
end
