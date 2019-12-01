class Api::V1::ChatController < ActionController::API
  def initialize
    @banfox_chat = BanfoxChatService.new
  end

  def get_chat_room
    @banfox_chat_response = @banfox_chat.get_room
    render :json => @banfox_chat_response
  end

  def send_message
    safe_params = params.permit(:message, :session_id, :room_code, :first)
    #SlackMessage.new("CQSEU4466","<!channel> Um contato foi feito pelo chat da LP. Clique no link para conversar. #{safe_params["session_id"]}").send_now if safe_params.first
    @banfox_chat_response = @banfox_chat.send_message(safe_params)
    render :json => @banfox_chat_response
  end

end
