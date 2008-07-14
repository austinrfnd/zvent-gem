module Zvent
  BASE_URL = "http://www.zvents.com/rest"  
  
  # A zvent session used to search and everything
  class Session < Base
    def initialize(api_key)
      #TODO: require API_KEY
      @api_key = api_key
    end
    
    # find events 
    # returns an array of events
    def find_events(location, options = {})
      #TODO: require location
      events = get_resources(BASE_URL+"/search?#{options.merge(:where => location, :key => @api_key).to_query}")
    end
    
    # find an event
    # returns a single event if successful
    # returns nil if nothing found
    def find_event(event_id, options = {})
    end
  end
end

# backported from rails
# I need to put this somewhere
class Hash
  def to_query(namespace = nil)
    collect do |key, value|
      value.to_query(namespace ? "#{namespace}[#{key}]" : key)
    end.sort * '&'
  end
end

class Object
  def to_query(key)
    "#{CGI.escape(key.to_s)}=#{CGI.escape(to_param.to_s)}"
  end
  
  def to_param
    to_s
  end    
end