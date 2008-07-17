module Zvent  
  # An object that represents a single event from zvents
  class Event < Base
    attr_accessor   :name, :artists, :price, :private, :editors_pick, :url, :approved,
                  :sc, :id, :images, :description, :vid, :color, :phone, :startTime,
                  :endTime, :zurl, :venue
    
    # expects the json hash that is given from zvents
    def initialize(event_hash)
      begin
        event_hash.each_pair{|key, value| self.send("#{key}=", value) }      
      rescue NoMethodError => e
        # Do nothing!
      end
    end
        
    # Does the event have any images?
    def images? ; !self.images.empty? ; end
    
    def deep_images?
      self.images? || (self.venue.nil? ? false : self.venue.images?)
    end
    
    # Returns the first image it sees.  First it checks the event for images thent the venue for images.
    # If none is found it will return nil
    def deep_image
      if self.images?
        self.images.first
      elsif self.venue
        self.venue.images? ? self.venue.images.first : nil                
      else
        nil
      end
    end
  end
end