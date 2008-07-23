module Zvent
  # An object that represents a single venue from zvents
  class Category < Base
    attr_accessor  :name, :pid, :id, :count
    
    def initialize(category_hash)
      begin
        category_hash.each_pair{|key, value| self.send("#{key}=", value) }
      rescue NoMethodError => e
        # Do nothing!
      end
    end    
  end
end