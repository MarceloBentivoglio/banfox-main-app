class SendSlackMessage

  def initialize(channel, content)
    @channel = channel
    @content = content
    response = RestClient.post(url, payload, headers)
  end

  private

  def url
    "https://slack.com/api/chat.postMessage"
  end

  def headers
    {
      content_type: :json,
      accept: :json,
      Authorization: "Bearer #{secret_api_key}"
    }
  end

  def payload
    {
      channel: @channel,
      text: @content
    }.to_json
  end

  def secret_api_key
    Rails.application.credentials[:slack][:oauth_access_token]
  end

end
