require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Performer do
  it "should describe images? as true if performer has images" do
    performer = Zvent::Performer.new({'images' => ['asdf.jpg']})
    performer.images?.should eql(true)
  end

  it "should return all real attributes" do
    performer = Zvent::Performer.new({:not_real_attribute => 'asdf', :name => 'name!', :description => 'a description'})
    performer.name.should eql("name!")
    performer.description.should eql('a description')
  end

  it "should describe images? as false if performer has no images" do
    performer = Zvent::Performer.new({'images' => []})
    performer.images?.should eql(false)
  end
end
