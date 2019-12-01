class BanfoxChatService
  APIHOST = "localhost:4000"

  def get_room
    url = "#{APIHOST}/api/v1/get_chat_room"
    response = RestClient.get(url)
    response
  end

  def send_message(params)
    url = "#{APIHOST}/api/v1/send_message"
    body = {}
    body[:message] = params["message"]
    body[:room_code] = params["room_code"]
    response = RestClient.post(url, body)
    response
  end
end
