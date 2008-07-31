require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Event do
  
  describe "venue?" do
    it "should return false if no venue" do
      event = Zvent::Event.new({})
      event.venue?.should eql(false)
    end
    
    it "should return true if there is a venue" do
      venue = Zvent::Venue.new({})
      event = Zvent::Event.new({'venue' => venue})      
      event.venue?.should eql(true)
    end
  end
  
  describe 'images?' do
    it "should be false if images" do
      event = Zvent::Event.new({'images' => ['asdf.jpg', 'best.jpg']})
      event.images?.should eql(true)
      event.deep_images?.should eql(true)
    end
  
    it "should be false if no images" do
      event = Zvent::Event.new({'images' => []})
      event.images?.should eql(false)
      event.deep_images?.should eql(false)
    end
    
    it "should be false if images is not in the array" do
      event = Zvent::Event.new({})
      event.images?.should eql(false)
      event.deep_images?.should eql(false)      
    end
  end
  
  describe 'deep_images?' do
    it "should be true if venue exists" do    
      venue = Zvent::Venue.new({'images' => ['asdf.jpg']})
      event = Zvent::Event.new({'images' => [], 'venue' => venue})
      event.images?.should eql(false)
      event.deep_images?.should eql(true)
    end
  end
  
  describe 'categories' do
    it "should allow to set categories" do
      event = Zvent::Event.new({:categories=>[{:name => 'Spelunking', :pid => 3, :id => 2, :count => 1},
                                              {:name => 'Cleaning', :pid => 1, :id => 4, :count => 0}]})
      event.categories.length.should eql(2)
      event.categories.each{|c| c.should be_kind_of(Zvent::Category)}
      event.category?.should be_true
    end
    
    it "should have no categories" do
      event = Zvent::Event.new({})      
      event.category?.should be_false
    end
  end
  
  describe 'image' do
    it "should return images of all size" do
      event = Zvent::Event.new({'images' => [{'url' => 'asdf.jpg'}, {'url' => 'best.jpg'}]})
      event.image('tiny').should =~ /_tiny.jpg/
      event.image('medium').should =~ /_medium.jpg/
      event.image('primary').should =~ /_primary.jpg/
      event.image('featured').should =~ /_featured.jpg/      
    end

    it "should raise an error if I give it an image size that isn't accepted" do
      event = Zvent::Event.new({'images' => [{'url' => 'asdf.jpg'}, {'url' => 'best.jpg'}]})
      lambda {event.image('HUMUNGO')}.should raise_error(Zvent::InvalidImageSize)
    end
    
    it "should return nil if no images" do
      event = Zvent::Event.new({'images' => []})      
      event.image.should be_nil  
      
      event = Zvent::Event.new({})            
      event.images.should be_nil
    end
    
    it "should return the original image if given no argument" do
      event = Zvent::Event.new({'images' => [{'url' => 'asdf.jpg'}, {'url' => 'best.jpg'}]})
      event.image.should eql('asdf.jpg')            
    end
  end
  
  describe 'startTime' do
    before :each do
      venue = Zvent::Venue.new({'timezone' => 'US/Pacific'})
      @event = Zvent::Event.new({'startTime' => 'Sun Mar 12 15:00:00 GMT 2006', 'venue' => venue})
    end
    
    it "should return a dateTime object" do
      @event.startTime.should be_kind_of(DateTime)
    end
    
    it "should return UTC by default" do
      @event.startTime.to_s.should eql('2006-03-12T23:00:00+00:00')
    end
    
    it "should return local time if utc is set to false" do
      @event.startTime(false).to_s.should eql('2006-03-12T15:00:00+00:00')      
    end
  end

  describe 'endTime' do
    before :each do
      venue = Zvent::Venue.new({'timezone' => 'US/Pacific'})
      @event = Zvent::Event.new({'startTime' => 'Sun Mar 12 15:00:00 GMT 2006', 
                                 'endTime' => 'Sun Mar 12 17:00:00 GMT 2006', 'venue' => venue})
    end
    
    it "should return a dateTime object" do
      @event.endTime.should be_kind_of(DateTime)
    end
    
    it "should return UTC by default" do
      @event.endTime.to_s.should eql('2006-03-13T01:00:00+00:00')
    end
    
    it "should return local time if utc is set to false" do
      @event.endTime(false).to_s.should eql('2006-03-12T17:00:00+00:00')      
    end
    
    it "should return nil if there is no endTime" do
      @event = Zvent::Event.new({'venue' => Zvent::Venue.new({'timezone' => 'US/Pacific'})})      
      
      @event.endTime.should be_nil
    end
  end
  
  describe "deep_image" do
    it "should return the event image if an event has an image" do
      venue = Zvent::Venue.new({'images' => ['asdf2.jpg']})
      event = Zvent::Event.new({'images' => [{'url' => 'asdf.jpg'}], 'venue' => venue})      
      event.deep_image.should eql('asdf.jpg')
    end
    
    it "should return the venue image if no image exists" do
      venue = Zvent::Venue.new({'images' => ['asdf2.jpg']})
      event = Zvent::Event.new({'images' => [], 'venue' => venue})
      event.deep_image.should eql('asdf2.jpg')      
    end
    
    it "should return nil if neither event or venue contains an image" do
      venue = Zvent::Venue.new({'images' => []})
      event = Zvent::Event.new({'images' => [], 'venue' => venue})      
      event.deep_image.should be_nil      
      event = Zvent::Event.new({'images' => []})      
      event.deep_image.should be_nil
    end
    
    it "should return images of all sizes" do
      event = Zvent::Event.new({'images' => [{'url' => 'asdf.jpg'}, {'url' => 'best.jpg'}]})
      event.deep_image('tiny').should =~ /_tiny.jpg/
      event.deep_image('medium').should =~ /_medium.jpg/
      event.deep_image('primary').should =~ /_primary.jpg/
      event.deep_image('featured').should =~ /_featured.jpg/      
    end
    
    it "should raise an error if I give it an image size that isn't accepted" do
      event = Zvent::Event.new({'images' => ['asdf.jpg', 'best.jpg']})
      lambda {event.deep_image('HUMUNGO')}.should raise_error(Zvent::InvalidImageSize)
    end
  end
  
  it "should be a well formatted event" do
    event = Zvent::Event.new({:age_suitability => '18 or older'})
    event.age_suitability.should eql('18 or older')
  end
end