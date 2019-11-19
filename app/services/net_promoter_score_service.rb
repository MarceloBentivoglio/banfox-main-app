class NetPromoterScoreService
  def self.call(feedback)
    seller = feedback.user&.seller
    questions_text = ""
    feedback.questions.each do |question|
      questions_text += "\n #{question["question"]}: #{question["answer"]}"
    end
    message = "Rating: #{feedback.rating} \n Recomendaria a Banfox? #{feedback.recommend_banfox} #{questions_text}"
    SlackMessage.new("CQPBSJBPS", "<!channel> #{seller.company_name} envio o seguinte feedback: \n #{message}")
  end
end
