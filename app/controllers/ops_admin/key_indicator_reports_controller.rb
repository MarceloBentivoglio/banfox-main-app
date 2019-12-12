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
      request_allowed = @history.count <= 10

      request_message = request_allowed ? 'Request was allowed!' : 'Request was denied!'
      SlackMessage.new('CR87XF2US', "#{current_user.email} requested a credit analysis report\nTotal of requests of this user: #{@history.count}\n#{request_message}").send_now

      respond_to do |format|
        begin
          if request_allowed
            @key_indicator_report_request = Risk::Service::KeyIndicatorReportRequest.call(input_data, current_user)
            @key_indicator_report_request.reload

            format.html { redirect_to report_ops_admin_key_indicator_report_path(@key_indicator_report_request.key_indicator_reports.first) }
          else
            @key_indicator_report = Risk::KeyIndicatorReport.new
            @key_indicator_report.input_data = input_data[:cnpjs]&.join(',')

            flash[:error] = 'Você ultrapassou o limite de relatórios. Uma mensagem já foi enviada para nossa equipe e entraremos em contato em breve.'
            format.html { render :new }
          end
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
