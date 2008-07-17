require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Event do
  
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
  end
  
  describe 'deep_images?' do
    it "should be true if venue exists" do    
      venue = Zvent::Venue.new({'images' => ['asdf.jpg']})
      event = Zvent::Event.new({'images' => [], 'venue' => venue})
      event.images?.should eql(false)
      event.deep_images?.should eql(true)
    end
  end
  
  describe 'image' do
    it "should return images of all size" do
      event = Zvent::Event.new({'images' => ['asdf.jpg', 'best.jpg']})
      event.image('tiny').should =~ /_tiny.jpg/
      event.image('medium').should =~ /_medium.jpg/
      event.image('primary').should =~ /_primary.jpg/
      event.image('featured').should =~ /_featured.jpg/      
    end

    it "should raise an error if I give it an image size that isn't accepted" do
      event = Zvent::Event.new({'images' => ['asdf.jpg', 'best.jpg']})
      lambda {event.image('HUMUNGO')}.should raise_error(Zvent::InvalidImageSize)
    end
    
    it "should return nil if no images" do
      event = Zvent::Event.new({'images' => []})      
      event.image.should be_nil  
    end
  end
  
  describe "deep_image" do
    it "should return the event image if an event has an image" do
      venue = Zvent::Venue.new({'images' => ['asdf2.jpg']})
      event = Zvent::Event.new({'images' => ['asdf.jpg'], 'venue' => venue})      
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
      event = Zvent::Event.new({'images' => ['asdf.jpg', 'best.jpg']})
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
end