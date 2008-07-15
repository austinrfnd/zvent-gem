module Zvent
  # A zvent session used to search and everything
  class Session < Base
    def initialize(api_key)
      #TODO: require API_KEY
      @api_key = api_key
    end
    
    # find events 
    # returns an array of events
    # {:event_count => 10, :events => [<# event>, ...]}
    # options
    # - as_json (defaults => false) returns the json from zvents without any transformation
    def find_events(location, zvent_options = {}, options = {})      
      #location is required
      raise Zvent::NoLocationError.new if location.strip.empty?
      
      #grab the json from zvents
      json_ret = get_resources(BASE_URL+"/search?#{zvent_options.merge(:where => location).to_query}")
      
      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_zvents_json(json_ret)
    end
    
    # find an event
    # returns a single event if successful
    # <# event>
    # returns nil if nothing found
    # options
    # - as_json (defaults => false) returns the json from zvents without any transformation    
    def find_event(event_id, zvent_options={}, options = {})
      # event_id is required
      raise Zvent::NoIdError if event_id.strip.empty?
      
      #grab the json from zvents
      json_ret = get_resources(BASE_URL+"/event?#{zvent_options.merge(:id => event_id).to_query}")
      
      options[:as_json] ? json_ret : objectify_zvents_json(json_ret)[:events].first
    end
    
    private
    def objectify_zvents_json(json)
      venues = objectify_venues(json['rsp']['content']['venues'])
      {:events => objectify_events(json['rsp']['content']['events'], venues),
       :event_count => json['rsp']['content']['event_count']||0}      
    end
    
    # returns a hash of venues
    # {venue_id => <# venue >, ...}
    def objectify_venues(venues)
      venue_hash = {}
      venues.each do |venue|
        v = objectify_venue(venue)
        venue_hash[v.id] = v
      end if venues && !venues.empty?
      venue_hash
    end
    
    def objectify_events(events, venues_hash)
      (events && !events.empty?) ? events.collect{|e| objectify_event(e, venues_hash[e['vid']])} : []        
    end
      
    def objectify_event(event_hash, venue)
      Event.new(event_hash.merge(:venue => venue))
    end
    
    def objectify_venue(venue) ; Venue.new(venue) ; end
  end
end

# backported from rails
# TODO: I need to put this somewhere
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