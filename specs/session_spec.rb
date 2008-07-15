require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Session do
  it "should search events" do  
    mock_event_search      
    zvent_session = Zvent::Session.new('API_KEY')    
    events = zvent_session.find_events('93063')
    events.should be_kind_of(Array) 
    events.each{|event| event.should be_kind_of(Zvent::Event)}
  end
  
  it "should return the json only if options[:as_json] is true"
  
  private
  def mock_event_search
    @http_mock = mock('http')
    @http_mock.stub!(:get)
    @response_mock = mock(Net::HTTPResponse)
    @response_mock.stub!(:body).and_return(SEARCH_RESULTS)
    Net::HTTP.stub!(:start).and_yield(@http_mock).and_return(@response_mock)    
  end
end