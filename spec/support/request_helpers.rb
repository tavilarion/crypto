module Support
  module Request
    def json
      JSON.parse(last_response.body).deep_symbolize_keys
    end
  end
end
