class TraceExceptionsController < ApplicationController
  before_action :set_trace_exception, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin

  # GET /trace_exceptions
  # GET /trace_exceptions.json
  def index
    @trace_exceptions = TraceException.all
  end

  # GET /trace_exceptions/1
  # GET /trace_exceptions/1.json
  def show
  end

  # GET /trace_exceptions/new
  def new
    @trace_exception = TraceException.new
  end

  # GET /trace_exceptions/1/edit
  def edit
  end

  # POST /trace_exceptions
  # POST /trace_exceptions.json
  def create
    @trace_exception = TraceException.new(trace_exception_params)

    respond_to do |format|
      if @trace_exception.save
        format.html { redirect_to @trace_exception, notice: 'Trace exception was successfully created.' }
        format.json { render :show, status: :created, location: @trace_exception }
      else
        format.html { render :new }
        format.json { render json: @trace_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trace_exceptions/1
  # PATCH/PUT /trace_exceptions/1.json
  def update
    respond_to do |format|
      if @trace_exception.update(trace_exception_params)
        format.html { redirect_to @trace_exception, notice: 'Trace exception was successfully updated.' }
        format.json { render :show, status: :ok, location: @trace_exception }
      else
        format.html { render :edit }
        format.json { render json: @trace_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trace_exceptions/1
  # DELETE /trace_exceptions/1.json
  def destroy
    @trace_exception.destroy
    respond_to do |format|
      format.html { redirect_to trace_exceptions_url, notice: 'Trace exception was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trace_exception
      @trace_exception = TraceException.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trace_exception_params
      params.require(:trace_exception).permit(:message, :trace, :instance_variables, :instance_variable_names, :rack_session, :request_method, :query_hash, :request_params, :query_params, :path, :env)
    end

    def authenticate_admin
      return if current_user.admin?
      redirect_to "/"
    end
end
