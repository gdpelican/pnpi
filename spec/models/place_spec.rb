require 'spec_helper'

describe Place do
  
  before :each do
    @place = build :place, :resource
  end
  
  it "should have an address" do
    @place.address.should == "555 Any Street, Springfield, USA"
    @place.should be_valid
  end
  
  it "should have events" do
    @place.should respond_to :events
  end
  
  it "should have owners" do
    build(:person, places: [@place]).save
    @place.owners.size.should == 1
    @place.owners.first.name.should == 'test person'
    @place.owners.first.type.should == 'Person'
  end
 
end
