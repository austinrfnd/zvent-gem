require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Venue do
  it "should describe images? as true if venue has images" do
    venue = Zvent::Venue.new({'images' => ['asdf.jpg']})
    venue.images?.should eql(true)
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
end