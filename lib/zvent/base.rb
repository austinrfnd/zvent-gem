module Zvent
  class Base
    def get_resources(url)
      url = URI.parse(url)
      
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get(url.path + "&format=json")
      }
      
      resources = JSON.parse(res.body)
      return resources      
    end
  end
end