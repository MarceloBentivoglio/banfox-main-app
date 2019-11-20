class NetPromoterScoreService
  def self.call(feedback)
    seller = feedback.user&.seller
    questions_text = ""
    feedback.questions.each do |question|
      if question["question"] == "Se a Banfox deixasse de existir, como você se sentiria?"
        case question["answer"]
        when "0"
          question["answer"] = "Muito preocupado"
        when "1"
          question["answer"] = "Preocupado"
        when "2"
          question["answer"] = "Indiferente"
        when "3"
          question["answer"] = "Não sei dizer"
        end
      end
      questions_text += "\n *#{question["question"]}* #{question["answer"]}"
    end
    message = "*Rating* #{feedback.rating} \n *Recomendaria a Banfox?* #{feedback.recommend_banfox} #{questions_text}"
    SlackMessage.new("CQPBSJBPS", "<!channel> #{seller&.company_name} envio o seguinte feedback: \n #{message}").send_now
  end
end
