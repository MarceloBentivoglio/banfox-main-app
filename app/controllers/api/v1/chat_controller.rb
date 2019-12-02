class Api::V1::ChatController < ActionController::API
  def initialize
    @banfox_chat = BanfoxChatService.new
  end

  def get_chat_room
    banfox_chat_response = JSON(@banfox_chat.get_room.body)

    if banfox_chat_response["created_at"] == ""
      created_at_format = DateTime.current.strftime("%H:%M:%S")
    else
      created_at_format = banfox_chat_response["created_at"].to_datetime&.strftime("%H:%M:%S")
    end

    response = {}
    response[:session_id] = banfox_chat_response["session_id"]
    response[:code] = banfox_chat_response["code"]
    response[:created_at] = created_at_format
    render :json => response
  end

  def send_message
    safe_params = params.permit(:message, :session_id, :room_code, :first)
    banfox_chat_response = JSON(@banfox_chat.send_message(safe_params).body)

    SlackMessage.new("CQSEU4466","<!channel> Um contato foi feito pelo chat da LP. Clique no link para conversar. #{safe_params["session_id"]}").send_now if safe_params["first"] == "true"
    
    if banfox_chat_response["created_at"] == ""
      created_at_format = DateTime.current.strftime("%H:%M:%S")
    else
      created_at_format = banfox_chat_response["created_at"].to_datetime&.strftime("%H:%M:%S")
    end

    response = {}
    response[:body] = banfox_chat_response["body"]
    response[:created_at] = created_at_format
    render :json => response
  end

end
