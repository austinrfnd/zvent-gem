require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Session do
  describe "find_events" do
    it "should be successful" do  
      find_event_returns :event_search    
      zvent_session = Zvent::Session.new('API_KEY')    
      events = zvent_session.find_events('93063')
      events.should be_kind_of(Hash)
      events[:event_count].should be_kind_of(Integer)
      events[:events].should be_kind_of(Array)
      events[:events].each{|event| event.should be_kind_of(Zvent::Event)}
      events[:events].each do |event|
        event.deep_image('medium') if event.deep_images?
      end
    end
  
    it "should return the json only if options[:as_json] is true" do
      find_event_returns :event_search    
      zvent_session = Zvent::Session.new('API_KEY')    
      events = zvent_session.find_events('93063', {}, {:as_json => true})      
      events.should be_kind_of(Hash)
    end
  
    it "should throw an error if no location is given" do
      zvent_session = Zvent::Session.new('API_KEY')
      lambda {zvent_session.find_events('')}.should raise_error(Zvent::NoLocationError)   
      lambda {zvent_session.find_events('  ')}.should raise_error(Zvent::NoLocationError)            
      lambda {zvent_session.find_events(nil)}.should raise_error(Zvent::NoLocationError)                  
    end
    
    it "should return empty array and 0 event_count if no events found" do
      find_event_returns :empty_event_search    
      zvent_session = Zvent::Session.new('API_KEY')
      events = zvent_session.find_events('93063')
      events[:events].should be_empty
      events[:events].should be_kind_of(Array)
      events[:event_count].should eql(0)
    end
  end
  
  describe "find_event" do
    it "should be successful" do
      find_event_returns :event
      zvent_session = Zvent::Session.new('API_KEY') 
      event = zvent_session.find_event('123456789')
      event.should be_kind_of(Zvent::Event)
      event.venue.should be_kind_of(Zvent::Venue)
      event.venue.address.should_not be_nil
    end
    
    it "should raise error if no event found" do
      find_event_returns(:unknown_event_id)
      zvent_session = Zvent::Session.new('API_KEY')
      lambda { zvent_session.find_event('12345689')}.should raise_error(Zvent::ZventApiFailure)
    end
    
    it "should throw error if no id is given" do
      zvent_session = Zvent::Session.new('API_KEY') 
      lambda {zvent_session.find_event('')}.should raise_error(Zvent::NoIdError)
      lambda {zvent_session.find_event("   ")}.should raise_error(Zvent::NoIdError)  
    end
    
    it "should return just the json if options[:as_json] is true" do
      find_event_returns :event
      zvent_session = Zvent::Session.new('API_KEY') 
      event_hash = zvent_session.find_event('123456789',{},{:as_json => true})
      event_hash.should be_kind_of(Hash)
    end
  end
  
  describe "initialize" do
    it "should raise error if not given an API key" do
      lambda {Zvent::Session.new('')}.should raise_error(Zvent::NoApiKeyError)
    end
    
    it "should not raise error if given an API key" do
      lambda {Zvent::Session.new('API_KEY')}.should_not raise_error(Zvent::NoApiKeyError)      
    end
  end
  
  private  

  def find_event_returns(name)
    @http_mock = mock('http')
    @http_mock.stub!(:get)
    @response_mock = mock(Net::HTTPResponse)
    @response_mock.stub!(:body).and_return(test_data(name))
    Net::HTTP.stub!(:start).and_yield(@http_mock).and_return(@response_mock)
  end
end