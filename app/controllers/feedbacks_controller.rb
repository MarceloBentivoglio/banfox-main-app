class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  layout 'empty_layout'

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new.tap do |feedback|
      feedback.user = current_user
      feedback.rating = params[:rating]
      feedback.recommend_banfox = params[:recommend_banfox] == "1"
      feedback.questions = [
        { 
          question: 'Se a Banfox deixasse de existir, como você se sentiria?',
          answer: params[:banfox_cease_to_exist]
        },
        {
          question: 'Explique: Se a Banfox deixasse de existir, como você se sentiria?',
          answer: params[:banfox_cease_to_exists_explanation],
        },
        {
          question: 'O que mais você gosta do produto da Banfox?',
          answer: params[:banfox_what_do_you_like]
        }
      ]
    end

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to sellers_dashboard_path, notice: 'Feedback was successfully created.' }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: 'Feedback was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:user_id, :rating, :recommend_banfox, :questions)
    end
end
