module Zvent
  # An object that represents a single venue from zvents
  class Venue < Base
    attr_accessor  :address, :city, :state, :country, :name, :latitude, 
                   :longitude, :zip, :private, :id, :timezone, :zurl,
                   :types, :images, :phone, :url, :description, :parent_id
    
    def initialize(venue_hash)
      venue_hash.each_pair do |key, value| 
        begin  
          self.send("#{key}=", value)
        rescue NoMethodError => e
          #do nothing
        end        
      end

      # Zvents Partner API
      self.zurl ||= venue_hash['link']
      self.description ||= venue_hash['summary']
      # TODO: external URLs
    end
    
    # Does the venue have any images
    def images? ; !(@images.nil? || @images.empty?) ; end
    
    def timezone? ; !(@timezone.nil? || @timezone.empty?) ; end
    
    # Returns the tz timezone object
    def tz_timezone ;  timezone? ? TZInfo::Timezone.get(@timezone) : nil ; end
  end
end