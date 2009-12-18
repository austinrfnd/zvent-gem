require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Session do
  it 'has a configurable base URL' do
    zvent_session = Zvent::Session.new('API_KEY',
      :base_url => 'http://fake.zvents.com/rest')

    zvent_session.should_receive(:get_resources).
      with('http://fake.zvents.com/rest/search?' +
        'image_size=none&where=San+Jose%2C+CA').
      and_raise('unimportant result')

    zvent_session.find_events('San Jose, CA') rescue 'unimportant result'
  end

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

  describe "find_venues" do
    it "should be successful" do
      search_for_venues_returns :venue_search
      zvent_session = Zvent::Session.new('API_KEY')
      venues = zvent_session.find_venues('Vancouver, BC')
      venues.should be_kind_of(Hash)
      venues[:venue_count].should == 16
      venues[:venues].length.should == 10
      venues[:venues].each{|venue| venue.should be_kind_of(Zvent::Venue)}
    end

    it "should return json if options[:as_json] is true" do
      search_for_venues_returns :venue_search
      zvent_session = Zvent::Session.new('API_KEY')
      venues = zvent_session.find_venues(
        'Vancouver, BC', {}, {:as_json => true})
      venues.should be_kind_of(Hash)
      venues['rsp']['content']['venues'][0].should be_kind_of(Hash)
    end

    it "should return empty array and 0 venue_count if no venues found" do
      search_for_venues_returns :empty_venue_search
      zvent_session = Zvent::Session.new('API_KEY')
      venues = zvent_session.find_venues('93063')
      venues[:venues].should be_empty
      venues[:venues].length.should == 0
      venues[:venue_count].should eql(0)
    end
  end

  describe "venue_events" do
    it "should be successful" do
      venue_events_returns :venue_events
      zvent_session = Zvent::Session.new('API_KEY')
      events = zvent_session.venue_events(9955)
      events[:event_count].should == 10
      events[:events].length.should == 10
      events[:events].each{|event| event.should be_kind_of(Zvent::Event)}
    end

    it "should raise an error if no venue ID is given" do
      zvent_session = Zvent::Session.new('API_KEY')
      lambda {zvent_session.venue_events(nil)}.should raise_error(Zvent::NoLocationError)
      lambda {zvent_session.venue_events('xyz')}.should raise_error(Zvent::NoLocationError)
    end

    it "should return json if options[:as_json] is true" do
      venue_events_returns :venue_events
      zvent_session = Zvent::Session.new('API_KEY')
      events = zvent_session.venue_events(
        9955, {}, {:as_json => true})
      events.should be_kind_of(Hash)
      events['rsp']['content']['events'][0].should be_kind_of(Hash)
    end
  end

  describe "find_performers" do
    it "should be successful" do
      search_for_performers_returns :performer_search
      zvent_session = Zvent::Session.new('API_KEY')
      performers = zvent_session.find_performers('Cirque du Soleil')
      performers.should be_kind_of(Hash)
      performers[:performer_count].should == 18
      performers[:performers].length.should == 10
      performers[:performers].each{|performer| performer.should be_kind_of(Zvent::Performer)}
    end

    it "should return json if options[:as_json] is true" do
      search_for_performers_returns :performer_search
      zvent_session = Zvent::Session.new('API_KEY')
      performers = zvent_session.find_performers(
        'Vancouver, BC', {}, {:as_json => true})
      performers.should be_kind_of(Hash)
      performers['rsp']['content']['groups'][0].should be_kind_of(Hash)
    end

    it "should return empty array and 0 performer_count if no performers found" do
      search_for_performers_returns :empty_performer_search
      zvent_session = Zvent::Session.new('API_KEY')
      performers = zvent_session.find_performers('Cirque du Soleil')
      performers[:performers].should be_empty
      performers[:performers].length.should == 0
      performers[:performer_count].should eql(0)
    end
  end

  describe "performer_events" do
    it "should be successful" do
      performer_events_returns :performer_events
      zvent_session = Zvent::Session.new('API_KEY')
      events = zvent_session.performer_events(9955)
      events[:event_count].should == 10
      events[:events].length.should == 10
      events[:events].each{|event| event.should be_kind_of(Zvent::Event)}
    end

    it "should raise an error if no performer ID is given" do
      zvent_session = Zvent::Session.new('API_KEY')
      lambda {zvent_session.performer_events(nil)}.should raise_error(Zvent::NoLocationError)
      lambda {zvent_session.performer_events('xyz')}.should raise_error(Zvent::NoLocationError)
    end

    it "should return json if options[:as_json] is true" do
      performer_events_returns :performer_events
      zvent_session = Zvent::Session.new('API_KEY')
      events = zvent_session.performer_events(
        9955, {}, {:as_json => true})
      events.should be_kind_of(Hash)
      events['rsp']['content']['events'][0].should be_kind_of(Hash)
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

  alias search_for_venues_returns find_event_returns
  alias venue_events_returns find_event_returns
  alias search_for_performers_returns find_event_returns
  alias performer_events_returns find_event_returns
end
