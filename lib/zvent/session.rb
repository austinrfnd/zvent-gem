module Zvent
  # A zvent session used to search and everything
  class Session < Base
    def initialize(api_key)
      #TODO: require API_KEY
      @api_key = api_key
    end
    
    # find events 
    # returns an array of events
    # options
    # - as_json (defaults => false)
    def find_events(location, zvent_options = {}, options = {})
      #TODO: require location
      json_ret = get_resources(BASE_URL+"/search?#{zvent_options.merge(:where => location, :key => @api_key).to_query}")
      objectify_zvents_json(json_ret)
    end
    
    # find an event
    # returns a single event if successful
    # returns nil if nothing found
    def find_event(event_id, zvent_options, options = {})
    end
    
    private
    def objectify_zvents_json(json)
      venues = objectify_venues(json['rsp']['content']['venues'])
      objectify_events(json['rsp']['content']['events'], venues)
    end
    
    #returns a hash of venues
    # {venue_id => <# venue >, ...}
    def objectify_venues(venues)
      venue_hash = {}
      venues.each do |venue|
        v = objectify_venue(venue)
        venue_hash[v.id] = v
      end
      venue_hash
    end
    
    def objectify_events(events, venues_hash)
      events.collect{|e| objectify_event(e, venues_hash[e['vid']])}
    end
      
    def objectify_event(event_hash, venue)
      Event.new(event_hash.merge(:venue => venue))
    end
    
    def objectify_venue(venue) ; Venue.new(venue) ; end
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