require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Base do
  it 'should handle zvent api return by raising error' do
    mock_invalid_api
    b = Zvent::Base.new
    lambda {b.get_resources('http://www.zvents.com/rest/')}.should raise_error(Zvent::ZventApiError)
  end
  
  it "should have the appropriate error message"
  
  private
  def mock_invalid_api
    @http_mock = mock('http')
    @http_mock.stub!(:get)
    @response_mock = mock(Net::HTTPResponse)
    @response_mock.stub!(:body).and_return(test_data(:invalid_api_key))
    Net::HTTP.stub!(:start).and_yield(@http_mock).and_return(@response_mock)    
  end
end