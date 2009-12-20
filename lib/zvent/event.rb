module Zvent  
  # An object that represents a single event from zvents
  class Event < Base    
    IMAGE_SIZES = ['tiny', 'medium', 'featured', 'primary', 'original']    
    
    attr_accessor :name, :artists, :price, :private, :editors_pick, :url, :approved,
                  :sc, :id, :images, :description, :vid, :color, :phone, :startTime,
                  :endTime, :zurl, :venue, :categories, :age_suitability
    
    # expects the json hash that is given from zvents
    def initialize(event_hash)
      event_hash.each_pair do |key, value| 
        begin  
          self.send("#{key}=", value)
        rescue NoMethodError => e
          #do nothing
        end        
      end

      # Zvents Partner API
      self.zurl ||= event_hash['link']
      self.startTime ||= event_hash['starttime']
    end
    
    # Get the start time of the event.  Events are guaranteed an start time.  
    # The function will return a DateTime object of the time.
    #
    # <b>options</b>
    # <tt>utc</tt> - Want the time in local (to the venue) or in UTC? Defaults to UTC
    def startTime(utc=true)
      # if there is no startTime return nil
      return nil if @startTime.nil?
      
      # Parse the startTime
      start_time = DateTime.parse(@startTime)
      
      # Decide if we need to return UTC or local time
      utc ? DateTime.parse(self.tz_timezone.local_to_utc(start_time).to_s) : start_time
    end
    
    # Get the end time of the event.  Events are not guaranteed an end time.    
    # The function will return a DateTime object of the time.  If there isn't an endtime it will return nil.  
    #
    # <b>options</b>
    # <tt>utc</tt> - Want the time in local (to the venue) or in UTC? Defaults to UTC
    def endTime(utc=true)
      # if there is no startTime return nil
      return nil if @endTime.nil?
      
      # Parse the startTime
      end_time = DateTime.parse(@endTime)
      
      # Decide if we need to return UTC or local time
      utc ? DateTime.parse(self.tz_timezone.local_to_utc(end_time).to_s) : end_time 
    end
            
    # Returns the tz timezone object from the venue
    def tz_timezone ; @venue.tz_timezone; end
        
    # Does the event have any images
    def images?  ; !(@images.nil? || @images.empty?); end
    
    # Does the event or venue have any images
    def deep_images?
      self.images? || (@venue.nil? ? false : @venue.images?)
    end
    
    # Categories takes in some json
    def categories=(categories_json)
      categories_json.each do |category|
        if @categories.nil?
          @categories = [Zvent::Category.new(category)]
        else
          @categories << Zvent::Category.new(category)
        end
      end if categories_json
    end
    
    # Does the event have any categories attached to it?
    def category? ; !(@categories.nil? || @categories.empty?) ; end
    
    # Returns the first image it sees from event.  If none is found it will return nil
    # <b>size</b>
    # * <tt>tiny</tt> - 44x44
    # * <tt>medium</tt> - 66x66
    # * <tt>featured</tt> - 150x150
    # * <tt>primary</tt> - 184x184
    # * <tt>original</tt> Will just grab the original image from zvents (default)    
    def image(size='original')
      self.images? ? convert_image(@images.first, size) : nil
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
        image = @images.first
      elsif self.venue
        image = @venue.images? ? @venue.images.first : nil                
      else
        image = nil
      end

      (image.nil?) ? image : convert_image(image, size)
    end
    
    # Checks to see if the event has a venue
    def venue? ; !(@venue.nil?) ; end
    
    private    
    # grab the size of the image requested  
    def convert_image(image, size)      
      # Apparently venue returns a different kind of image than event.
      image_url = image.kind_of?(Hash) ? image['url'] : image
      
      # if the size is original just return the image
      return image_url if size == 'original'

      # else grab the specific size
      IMAGE_SIZES.include?(size) ? image_url.insert(image_url.index('.jpg'), "_#{size}") : (raise Zvent::InvalidImageSize.new)
    end     
  end
end