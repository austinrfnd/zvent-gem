module Zvent
  BASE_URL = "http://www.zvents.com/rest"  

  # raised when no location is given when it is required
  class NoLocationError < StandardError; end
  
  # raised when no id proveded when it is required
  class NoIdError < StandardError; end
  
  # raise when not given an API key
  class NoApiKeyError < StandardError; end
        
  class Base
    
    # Get Json and parse it
    def get_resources(url)
      url = URI.parse(url)
      
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get(url.request_uri+"&format=json&key=#{@api_key}")
      }
      
      resources = JSON.parse(res.body)
      return resources      
    end
  end
end