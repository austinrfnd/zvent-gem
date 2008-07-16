module Zvent
  # A zvent session used to search and everything
  class Session < Base
    def initialize(api_key)
      #TODO: require API_KEY
      @api_key = api_key
    end
    
    # Use this method to find events from zvents.
    #
    # <b>Return</b>
    # returns a hash that contains an array of events and an event count  
    # {:event_count => 10, :events => [<# event>, ...]}
    # 
    # <b>Arguments</b>
    # 
    # location
    # * <tt>location</tt> - A string describing a location around which the search results will be restricted. (e.g., san francisco, ca or 94131). You can also specify a location using a longitude/latitude coordinate pair using the notation -74.0:BY:40.9    
    #  
    # zvent_options
    # * <tt>what</tt> - The string against which events are matched. (e.g., parade). (<tt>default</tt> = nil, which searches for everything)
    # * <tt>when</tt> - A string specifying a date range for the search (e.g., today, this week, next week, friday, etc.). Explicit date ranges can be specified by separating two dates with the word "to" (e.g., monday to thursday, 10/30/2007 to 11/4/2007). Leave this string blank to search all future events.	
    # * <tt>radius</tt> - The number of miles around the location (specified in the where field) to search. If this field is left blank, a default radius is supplied. The default radius varies according to the location specified in the where field.	
    # * <tt>limit</tt> - The maximum number of matching events to return. The default is 10 and maximum is 10. Zvents partners can exceed the maximum.(<tt>Default</tt> = 10.  <tt>Max</tt> = 25)
    # * <tt>offset</tt> - The number of events to skip from the beginning of the search results. If a search matches 1000 events, returning 25 events starting at offset 100 will return event numbers 100-125 that match the search. (<tt>Default</tt> = 0)
    # * <tt>trim</tt> - Set to 1 if repeating events should be trimmed from the search results. Set to 0 to return repeating events. If the trim option is enabled, only 1 event will be returned from each repeating series that matches the search. The number of events within the series that match the search is returned in the series_count response parameter. Defaults to 1.
    # * <tt>sort</tt> - Set to 1 to sort search results by start time. Set to 0 to sort search results by relevance. Defaults to 0.	
    # * <tt>cat</tt> - Restrict your search to items that belong to a specific category. You must provide a category identifier which can be determined using the categories API call.	
    #	* <tt>catex</tt> - Exclude items from a specific category from the search. You must provide a category identifier which can be determined using the categories API call.	
    #
    # options
    # * <tt>as_json</tt> - If set to true method will return the json from zvents without any transformation.  (<tt>false</tt> by default).
    #  
    # Examples:
    #   find_events('93063')
    #   => Finds any 10 events near the 93063 zip code area.
    #
    #   find_events('611 N. Brand Blvd. Glendale, Ca', {:what => 'dancing', :limit => 25})
    #   => Finds 25 events near the address that consists of dancing
    #
    #   find_events('611 N. Brand Blvd. Glendale, Ca', {:what => 'dancing'}, {:as_json => true})
    #   => Should return the json straight from zvents
    #
    def find_events(location, zvent_options = {}, options = {})      
      #location is required
      raise Zvent::NoLocationError.new if location.strip.empty?
      
      #grab the json from zvents
      json_ret = get_resources(BASE_URL+"/search?#{zvent_options.merge(:where => location).to_query}")
      
      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_zvents_json(json_ret)
    end
    
    # Use this method to return a single event from zvents
    #
    # <b>Return</b>
    # returns an single event.  If an event can not be found it will return nil
    # <# event>
    #  
    # <b>Arguments</b>
    # event_id
    # * <tt>id</tt> - ID of the event
    #
    # options
    # * <tt>as_json</tt> - If set to true method will return the json from zvents without any transformation.  (<tt>false</tt> by default).
    #  
    # Examples:
    #   find_event('1234')
    #   => Finds an event with the id of 1234
    #
    #   find_event('1234', {:as_json => true})
    #   => Finds an event with the id of 1234 and returns the json as it comes in from zvents
    def find_event(event_id, zvent_options={}, options = {})
      # event_id is required
      raise Zvent::NoIdError if event_id.strip.empty?
      
      #grab the json from zvents
      json_ret = get_resources(BASE_URL+"/event?#{zvent_options.merge(:id => event_id).to_query}")
      
      #return the json or objectified json
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
