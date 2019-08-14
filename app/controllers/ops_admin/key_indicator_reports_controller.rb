module OpsAdmin
  class KeyIndicatorReportsController < OpsAdmin::BaseController
    def create
      @key_indicator_report = Risk::Service::KeyIndicatorReport.new(params, Time.now + 1.day)
                                                              .call
      respond_to do |format|
        if @key_indicator_report.errors.empty? && @key_indicator_report.save
          format.html { redirect_to ops_admin_key_indicator_report_path(@key_indicator_report) }
        else
          format.html { render :new }
        end
      end
    end

    def show
      @key_indicator_report = Risk::KeyIndicatorReport.find(params[:id])
      @presenter = Risk::Presenter::KeyIndicatorReport.new(@key_indicator_report)
      @cnpj = params[:cnpj]
    end

    def new
      @key_indicator_report = Risk::KeyIndicatorReport.new
    end
  end
end
