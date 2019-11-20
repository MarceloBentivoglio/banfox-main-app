class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  layout 'empty_layout'

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new

    @seller_name = current_user.seller.full_name.titleize
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
        },
        {
          question: 'Como nós podemos melhorar? Alguma dica?',
          answer: params[:banfox_how_can_we_improve]
        }
      ]
    end

    respond_to do |format|
      if @feedback.save
        NetPromoterScoreService.call(@feedback)
        format.html { redirect_to store_installments_path, notice: 'Muito obrigado pelo seu feedback!' }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
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
