module Risk
  module Fetcher
    class NogordSerasa
      def self.call(cnpj)
        url = Rails.application.credentials[Rails.env.to_sym][:nogord_serasa]
        headers = { 
          Content_Type: "application/json",
          Authorization: Rails.application.credentials[:nogord_token]
        }
        body = { cnpj: cnpj.to_s }.to_json
        data_serialized = RestClient.post(url, body, headers)
        JSON.parse(data_serialized)
      end
    end
  end
end
