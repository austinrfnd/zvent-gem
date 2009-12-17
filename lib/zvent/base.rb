module Zvent
  # raised when no location is given when it is required
  class NoLocationError < StandardError; end
  
  # raised when no id proveded when it is required
  class NoIdError < StandardError; end
  
  # raise when not given an API key
  class NoApiKeyError < StandardError; end
  
  # raise when the API doesn't like the request
  class ZventApiError < StandardError; end
  
  # Raise when the API returns a failure
  class ZventApiFailure < StandardError ; end
  
  # Raises when asking for an invalid image size
  class InvalidImageSize < StandardError; end
        
  class Base
    
    # Get Json and parse it
    def get_resources(url)
      url = URI.parse(url)
      
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get(url.request_uri+"&format=json&key=#{@api_key}")
      }
      resources = JSON.parse(res.body)
      
      if resources['rsp']['status'] == 'error' 
        raise Zvent::ZventApiError.new(resources['rsp']['msg'])
      elsif resources['rsp']['status'] == 'failed'
        raise Zvent::ZventApiFailure.new(resources['rsp']['msg'])
      end
      
      return resources      
    end
  end
end