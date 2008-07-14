module Zvent
  BASE_URL = "http://www.zvents.com/rest"  
  
  # A zvent session used to search and everything
  class Session < Base
    def initialize(api_key)
      @api_key = api_key
    end
    
    # find events 
    # returns an array of events
    def find_events(location, options = {})
    end
    
    # find an event
    # returns a single event if successful
    # returns nil if nothing found
    def find_event(event_id, options = {})
    end
  end
end