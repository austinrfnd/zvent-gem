module Zvent
  class Session
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