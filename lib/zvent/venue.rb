module Zvent
  # A zvent session used to search and everything
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
  end
end