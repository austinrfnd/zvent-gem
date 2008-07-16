module Zvent  
  # An object that represents a single event from zvents
  class Event < Base
    attr_accessor :name, :artists, :price, :private, :editors_pick, :url, :approved,
                  :sc, :id, :images, :description, :vid, :color, :phone, :startTime,
                  :endTime, :zurl, :venue
    
    def initialize(event_hash)
      begin
        event_hash.each_pair{|key, value| self.send("#{key}=", value) }      
      rescue NoMethodError => e
        # Do nothing!
      end
    end
  end
end