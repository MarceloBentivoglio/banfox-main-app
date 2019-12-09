class BanfoxChatService
  #APIHOST = "localhost:4000"
  APIHOST = ENV.fetch('CHATAPIHOST')

  def get_room
    url = "#{APIHOST}/api/v1/get_chat_room"
    response = RestClient.get(url)
    response
  end

  def restore_room(code)
    url = "#{APIHOST}/api/v1/restore_chat_room/#{code}"
    response = RestClient.get(url)
    response
  end

  def send_message(params)
    url = "#{APIHOST}/api/v1/send_message"
    body = {}
    body[:message] = params["message"]
    body[:room_code] = params["room_code"]
    body[:sender_type] = "client"
    response = RestClient.post(url, body)
    response
  end

  def get_history(code)
    url = "#{APIHOST}/api/v1/get_history/#{code}"
    response = RestClient.get(url)
    response
  end

  def check_new_messages(code)
    url = "#{APIHOST}/api/v1/check_new_messages/#{code}?sent_from=banfox"
    response = RestClient.get(url)
    response
  end

  def enable_chat_api(secret_key)
    url = "#{APIHOST}/api/v1/enable_chat_api"
    body = {}
    body[:secret_key] = secret_key
    response = RestClient.put(url, body)
    response
  end

  def disable_chat_api(secret_key)
    url = "#{APIHOST}/api/v1/disable_chat_api"
    body = {}
    body[:secret_key] = secret_key
    response = RestClient.put(url, body)
    response
  end

  def check_api_availability
    url = "#{APIHOST}/api/v1/check_api_availability"
    response = RestClient.get(url)
    response
  end
end
