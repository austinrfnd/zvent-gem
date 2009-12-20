module Zvent
  # An object that represents a single venue from zvents
  class Performer < Base
    attr_accessor :name, :url, :id, :images, :description, :zurl

    def initialize(performer_hash)
      performer_hash.each_pair do |key, value|
        begin
          self.send("#{key}=", value)
        rescue NoMethodError => e
          #do nothing
        end
      end

      # Zvents Partner API
      self.zurl ||= performer_hash['link']
      self.description ||= performer_hash['summary']
    end

    # Does the performer have any images
    def images? ; !(@images.nil? || @images.empty?) ; end

    def timezone? ; !(@timezone.nil? || @timezone.empty?) ; end

    # Returns the tz timezone object
    def tz_timezone ;  timezone? ? TZInfo::Timezone.get(@timezone) : nil ; end
  end
end
