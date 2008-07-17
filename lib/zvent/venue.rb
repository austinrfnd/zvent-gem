module Zvent
  # An object that represents a single venue from zvents
  class Venue < Base
    attr_accessor  :address, :city, :state, :country, :name, :latitude, 
                   :longitude, :zip, :private, :id, :timezone, :zurl,
                   :types, :images, :phone, :url, :description, :parent_id
    
    def initialize(venue_hash)
      begin
        venue_hash.each_pair{|key, value| self.send("#{key}=", value) }
      rescue NoMethodError => e
        # Do nothing!
      end
    end
    
    # Does the venue have any images
    def images? ; !self.images.empty? ; end
  end
end