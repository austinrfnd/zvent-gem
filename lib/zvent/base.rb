module Zvent
  BASE_URL = "http://www.zvents.com/rest"  

  # raised when no location is given when it is required
  class NoLocationError < StandardError; end
        
  class Base
    def get_resources(url)
      url = URI.parse(url)
      
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get(url.request_uri+'&format=json')
      }
      
      resources = JSON.parse(res.body)
      return resources      
    end
  end
end