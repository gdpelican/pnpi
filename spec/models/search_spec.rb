require 'spec_helper'

describe Search do
  
  before :all do
    FactoryGirl.create_list :person, 10, :resource, active: true
    FactoryGirl.create_list :place, 10, :resource, active: true
    FactoryGirl.create_list :thing, 10, :resource, active: true
  end
  
  after :all do
    Resource.destroy_all
  end
  
  before :each do
    @all = build :search, :all
    @filter = build :search, :filter
  end
  
  it "should create a json search" do
    @all.as_json[:type].should eq 'all'
  end
  
  it "should retrieve results" do
    @all.as_json[:results].should have(Search::PAGE_SIZE).items
  end
  
  it "should know the total results of a query" do
    @all.as_json[:max_page].should eq(Resource.count / Search::PAGE_SIZE)
  end
  
  it "defaults to page 1" do
    @all.as_json[:page].should eq 1
  end
  
  it "should filter by type" do
    @filter.as_json[:max_page].should eq(Person.active.count / Search::PAGE_SIZE)
    @filter.as_json[:results].map { |result| result[:type].should eq 'Person' }
  end
  
end
