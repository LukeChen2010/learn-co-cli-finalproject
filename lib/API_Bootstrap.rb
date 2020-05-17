class API_Bootstrap

    def self.get_payload(url)
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        payload = JSON.parse(response.body)
        return payload
    end
    
end