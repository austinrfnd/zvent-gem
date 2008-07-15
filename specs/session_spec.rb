require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Session do
  describe "find_events" do
    it "should be successful" do  
      mock_event_search      
      zvent_session = Zvent::Session.new('API_KEY')    
      events = zvent_session.find_events('93063')
      events.should be_kind_of(Hash)
      events[:event_count].should be_kind_of(Integer)
      events[:events].should be_kind_of(Array)
      events[:events].each{|event| event.should be_kind_of(Zvent::Event)}
    end
  
    it "should return the json only if options[:as_json] is true" do
      mock_event_search      
      zvent_session = Zvent::Session.new('API_KEY')    
      events = zvent_session.find_events('93063', {}, {:as_json => true})      
      events.should be_kind_of(Hash)
    end
  
    it "should throw an error if no location is given" do
      zvent_session = Zvent::Session.new('API_KEY')
      lambda {zvent_session.find_events('')}.should raise_error(Zvent::NoLocationError)   
      lambda {zvent_session.find_events('  ')}.should raise_error(Zvent::NoLocationError)            
    end
    
    it "should handle json read errors"
    
    it "should return empty array and 0 event_count if no events found" do
      mock_empty_event_search      
      zvent_session = Zvent::Session.new('API_KEY')
      events = zvent_session.find_events('93063')
      events[:events].should be_empty
      events[:events].should be_kind_of(Array)
      events[:event_count].should eql(0)
    end
  end
  
  describe "find_event" do
    it "should be successful" do
      mock_get_event
      zvent_session = Zvent::Session.new('API_KEY') 
      event = zvent_session.find_event('123456789')
      event.should be_kind_of(Zvent::Event)
      event.venue.should be_kind_of(Zvent::Venue)
    end
    
    it "should be return nil if no event found"
    
    it "should handle json read errors"
    
    it "should throw error if no id is given" do
      zvent_session = Zvent::Session.new('API_KEY') 
      lambda {zvent_session.find_event('')}.should raise_error(Zvent::NoIdError)
      lambda {zvent_session.find_event("   ")}.should raise_error(Zvent::NoIdError)  
    end
    
    it "should return just the json if options[:as_json] is true" do
      mock_get_event
      zvent_session = Zvent::Session.new('API_KEY') 
      event_hash = zvent_session.find_event('123456789',{},{:as_json => true})
      event_hash.should be_kind_of(Hash)
    end
  end
  
  private  
  def mock_event_search
    @http_mock = mock('http')
    @http_mock.stub!(:get)
    @response_mock = mock(Net::HTTPResponse)
    @response_mock.stub!(:body).and_return(SEARCH_RESULTS)
    Net::HTTP.stub!(:start).and_yield(@http_mock).and_return(@response_mock)    
  end
  
  def mock_get_event    
    @http_mock = mock('http')
    @http_mock.stub!(:get)
    @response_mock = mock(Net::HTTPResponse)
    @response_mock.stub!(:body).and_return(EVENT_RESULT)
    Net::HTTP.stub!(:start).and_yield(@http_mock).and_return(@response_mock)    
  end
  
  def mock_empty_event_search
    @http_mock = mock('http')
    @http_mock.stub!(:get)
    @response_mock = mock(Net::HTTPResponse)
    @response_mock.stub!(:body).and_return(EMPTY_SEARCH_RESULTS)
    Net::HTTP.stub!(:start).and_yield(@http_mock).and_return(@response_mock)        
  end    
end