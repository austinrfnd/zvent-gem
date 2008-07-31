require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Venue do
  it "should describe images? as true if venue has images" do
    venue = Zvent::Venue.new({'images' => ['asdf.jpg']})
    venue.images?.should eql(true)
  end
  
  it "should return all real attributes" do
    venue = Zvent::Venue.new({:not_real_attribute => 'asdf', :name => 'name!', :city => 'in my city'})
    venue.name.should eql("name!")
    venue.city.should eql('in my city')
  end

  it "should describe images? as false if venue has no images" do
    venue = Zvent::Venue.new({'images' => []})
    venue.images?.should eql(false)    
  end

  it "should return tz timezone object" do
    venue = Zvent::Venue.new({'timezone' => 'US/Pacific'})
    venue.tz_timezone
    venue.tz_timezone.should be_kind_of(TZInfo::Timezone)
  end
  
  it "tz_timezone should return nil if no timezone" do
    venue = Zvent::Venue.new({})  
    venue.tz_timezone.should be_nil
  end
  
  describe "timezone?" do
    it "should return false if no timezone" do
      venue = Zvent::Venue.new({})      
      venue.timezone?.should eql(false)
    end
    
    it "should return false if there is a timezone" do
      venue = Zvent::Venue.new({'timezone' => 'US/Pacific'})      
      venue.timezone?.should eql(true)
    end    
  end
end