module Zvent  
  # An object that represents a single event from zvents
  class Event < Base    
    IMAGE_SIZES = ['tiny', 'medium', 'featured', 'primary', 'original']    
    
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
        
    # Returns the tz timezone object from the venue
    def tz_timezone ; self.venue.tz_timezone ; end
        
    # Does the event have any images?
    def images? ; !self.images.empty? ; end
    
    def deep_images?
      self.images? || (self.venue.nil? ? false : self.venue.images?)
    end
    
    # Returns the first image it sees.  First it checks the event for images thent the venue for images.
    # If none is found it will return nil
    # 
    # <b>size</b>
    # * <tt>tiny</tt> - 44x44
    # * <tt>medium</tt> - 66x66
    # * <tt>featured</tt> - 150x150
    # * <tt>primary</tt> - 184x184
    # * <tt>original</tt> Will just grab the original image from zvents (default)
    def deep_image(size='original')
      image = nil
      if self.images?
        image = self.images.first
      elsif self.venue
        image = self.venue.images? ? self.venue.images.first : nil                
      else
        image = nil
      end
      (image.nil? || size == 'original') ? image : convert_image(image, size)
    end
    
    private    
    # grab the size of the image requested  
    def convert_image(image, size)
      IMAGE_SIZES.include?(size) ? image.insert(image.index('.jpg'), "_#{size}") : (raise Zvent::InvalidImageSize.new)
    end     
  end
end