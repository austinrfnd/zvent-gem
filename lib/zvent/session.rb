module Zvent
  # A zvent session used to search and everything
  class Session < Base
    DEFAULT_BASE_URL = "http://www.zvents.com/rest"

    # Default zvents arguments
    # Image_size = none assures we just get the plain file name.  Transformations to different sizes are done within the gem
    ZVENTS_DEFAULT_ARGUMENTS = {:image_size => 'none'}
    
    # Initializes the session object.  It requires an API key
    def initialize(api_key, options = {})
      raise Zvent::NoApiKeyError.new if !api_key || api_key.strip.empty?
      @api_key = api_key
      @base_url = options[:base_url] || DEFAULT_BASE_URL
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
      raise Zvent::NoLocationError.new if !location || location.strip.empty?
      
      #grab the json from zvents
      json_ret = get_resources(@base_url+"/search?#{zvent_options.merge(:where => location).merge(ZVENTS_DEFAULT_ARGUMENTS).to_query}")
      
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
      json_ret = get_resources(@base_url+"/event?#{zvent_options.merge(:id => event_id).merge(ZVENTS_DEFAULT_ARGUMENTS).to_query}")

      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_zvents_json(json_ret)[:events].first
    end

    # Use this method to find venues from zvents.
    #
    # <b>Return</b>
    # returns a hash that contains an array of venues and a venue count
    # {:venue_count => 10, :venues => [<# venue>, ...]}
    #
    # <b>Arguments</b>
    #
    # location
    # * <tt>location</tt> - A string describing a location around which the search results will be restricted. (e.g., san francisco, ca or 94131). You can also specify a location using a longitude/latitude coordinate pair using the notation -74.0:BY:40.9
    #
    # zvent_options
    # * <tt>what</tt> - The string against which venues are matched. (e.g., parade). (<tt>default</tt> = nil, which searches for everything)
    # * <tt>radius</tt> - The number of miles around the location (specified in the where field) to search. If this field is left blank, a default radius is supplied. The default radius varies according to the location specified in the where field.
    # * <tt>limit</tt> - The maximum number of matching venues to return. The default is 10 and maximum is 10. Zvents partners can exceed the maximum.(<tt>Default</tt> = 10.  <tt>Max</tt> = 25)
    # * <tt>offset</tt> - The number of venues to skip from the beginning of the search results. If a search matches 1000 venues, returning 25 venues starting at offset 100 will return venue numbers 100-125 that match the search. (<tt>Default</tt> = 0)
    # * <tt>vt</tt> - Restrict your search to items that belong to a specific venue type. You must provide a venue type id.
    #
    # options
    # * <tt>as_json</tt> - If set to true method will return the json from zvents without any transformation.  (<tt>false</tt> by default).
    #
    # Examples:
    #   find_venues('93063')
    #   => Finds any 10 venues near the 93063 zip code area.
    #
    #   find_venues('611 N. Brand Blvd. Glendale, Ca', {:what => 'museum', :limit => 25})
    #   => Finds 25 venues near the address that match 'museum'
    #
    #   find_venues('611 N. Brand Blvd. Glendale, Ca', {:what => 'museum'}, {:as_json => true})
    #   => Should return the json straight from zvents
    #
    def find_venues(location, zvent_options = {}, options = {})
      #location is required
      raise Zvent::NoLocationError.new if !location || location.strip.empty?

      #grab the json from zvents
      json_ret = get_resources(@base_url+"/search_for_venues?#{zvent_options.merge(:where => location).merge(ZVENTS_DEFAULT_ARGUMENTS).to_query}")

      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_venues_json(json_ret)
    end

    # Use this method to find events at a given venue from zvents.
    #
    # <b>Return</b>
    # returns a hash that contains an array of events and an event count
    # {:event_count => 10, :events => [<# event>, ...]}
    #
    # <b>Arguments</b>
    #
    # venue_id
    # * <tt>venue_id</tt> - ID of the venue, gleaned from an earlier Zvents call
    #
    # zvent_options
    # * <tt>limit</tt> - The maximum number of matching events to return. The default is 10 and maximum is 10. Zvents partners can exceed the maximum.(<tt>Default</tt> = 10.  <tt>Max</tt> = 25)
    # * <tt>offset</tt> - The number of events to skip from the beginning of the search results. If a search matches 1000 events, returning 25 events starting at offset 100 will return event numbers 100-125 that match the search. (<tt>Default</tt> = 0)
    # * <tt>sd</tt> - Return only events that start on or after this date. (format: MM/DD/YYYY, defaults to today)
    # * <tt>ed</tt> - Return only events that start on or before this date. This parameter can be used in conjunction with sd to return events within a specific date range. (format: MM/DD/YYYY)
    # * <tt>st</tt> - Return only events that start at or after this time. (format: seconds since the epoch, e.g., 1142399089)
    # * <tt>et</tt> - Return only events that start at or before this time. This parameter can be used in conjunction with st to return events within a specific time range. (format: seconds since the epoch, e.g., 1142399089)
    #
    # options
    # * <tt>as_json</tt> - If set to true method will return the json from zvents without any transformation.  (<tt>false</tt> by default).
    #
    # Examples:
    #   venue_events(9955)
    #   => Finds any 10 events for venue ID 9955
    #
    #   venue_events(venue.id)
    #   => Finds any 10 events for the given Zvents::Venue
    #
    #   venue_events(venue.id, {:sd => '12/31/2009'}, {:as_json => true})
    #   => Finds events starting on New Year's Eve, and returns json
    def venue_events(venue_id, zvent_options = {}, options = {})
      venue_id = venue_id.to_i
      raise Zvent::NoLocationError.new if venue_id == 0

      #grab the json from zvents
      json_ret = get_resources(@base_url+"/venue_events?#{zvent_options.merge(:id => venue_id).merge(ZVENTS_DEFAULT_ARGUMENTS).to_query}")

      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_zvents_json(json_ret)
    end

    # Use this method to find performers from zvents.
    #
    # <b>Return</b>
    # returns a hash that contains an array of performers and a performer count
    # {:performer_count => 10, :performers => [<# performer>, ...]}
    #
    # <b>Arguments</b>
    #
    # what
    # * <tt>what</tt> - The string against which items are matched in the search. (e.g., parade).
    #
    # zvent_options
    # * <tt>limit</tt> - The maximum number of matching performers to return.
    #
    # Examples:
    #   find_performers('Cirque du Soleil')
    #   => Finds any 10 performers matching Cirque du Soleil
    #
    #   find_performers('Cirque du Soleil', :limit => 1)
    #   => Finds any 1 performer matching Cirque du Soleil
    #
    #   find_performers('Cirque du Soleil', {:as_json => true})
    #   => Finds performers and returns the result as JSON
    def find_performers(what, zvent_options = {}, options = {})
      #grab the json from zvents
      json_ret = get_resources(@base_url+"/search_for_performers?#{zvent_options.merge(:what => what).merge(ZVENTS_DEFAULT_ARGUMENTS).to_query}")

      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_performers_json(json_ret)
    end

    # Use this method to find events for a given performer from zvents.
    #
    # <b>Return</b>
    # returns a hash that contains an array of events and an event count
    # {:event_count => 10, :events => [<# event>, ...]}
    #
    # <b>Arguments</b>
    #
    # performer_id
    # * <tt>performer_id</tt> - ID of the performer, gleaned from an earlier Zvents call
    #
    # zvent_options
    # * <tt>limit</tt> - The maximum number of matching events to return. The default is 10 and maximum is 10. Zvents partners can exceed the maximum.(<tt>Default</tt> = 10.  <tt>Max</tt> = 25)
    # * <tt>when</tt> - A string specifying a date range for the search (e.g., today, this week, next week, friday, etc.). Explicit date ranges can be specified by separating two dates with the word "to" (e.g., monday to thursday, 10/30/2007 to 11/4/2007). Leave this string blank to search all future events.	
    #
    # options
    # * <tt>as_json</tt> - If set to true method will return the json from zvents without any transformation.  (<tt>false</tt> by default).
    #
    # Examples:
    #   performer_events(9955)
    #   => Finds any 10 events for performer ID 9955
    #
    #   performer_events(performer.id)
    #   => Finds any 10 events for the given Zvents::Performer
    #
    #   performer_events(performer.id, {:sd => '12/31/2009'}, {:as_json => true})
    #   => Finds events starting on New Year's Eve, and returns json
    def performer_events(performer_id, zvent_options = {}, options = {})
      performer_id = performer_id.to_i
      raise Zvent::NoLocationError.new if performer_id == 0

      #grab the json from zvents
      json_ret = get_resources(@base_url+"/performer_events?#{zvent_options.merge(:id => performer_id).merge(ZVENTS_DEFAULT_ARGUMENTS).to_query}")

      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_zvents_json(json_ret)
    end

    protected
    def objectify_zvents_json(json)
      venues = objectify_venues(json['rsp']['content']['venues'])
      {:events => objectify_events(json['rsp']['content']['events'], venues),
       :event_count => json['rsp']['content']['event_count']||0}
    end

    def objectify_venues_json(json)
      {:venues => objectify_venues(json['rsp']['content']['venues']).values,
       :venue_count => json['rsp']['content']['venue_count']||0}
    end

    def objectify_performers_json(json)
      {:performers => objectify_performers(
          json['rsp']['content']['groups']).values,
       :performer_count => json['rsp']['content']['group_count']||0}
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

    # returns a hash of performers
    # {performer_id => <# performer >, ...}
    def objectify_performers(performers)
      performer_hash = {}
      performers.each do |performer|
        p = objectify_performer(performer)
        performer_hash[p.id] = p
      end if performers && !performers.empty?
      performer_hash
    end

    # returns an array of events
    def objectify_events(events, venues_hash)
      (events || []).collect do |e|
        objectify_event(e, venues_hash[e['vid'] || e['venue_id']])
      end
    end

    # Turns the event json into an event object
    def objectify_event(event_hash, venue) ; Event.new(event_hash.merge(:venue => venue)) ; end

    # Turns the venue json into a venue object
    def objectify_venue(venue) ; Venue.new(venue) ; end

    # Turns the performer json into a performer object
    def objectify_performer(performer) ; Performer.new(performer) ; end
  end
end
