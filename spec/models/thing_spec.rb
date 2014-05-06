require 'spec_helper'

describe Thing do
  
  before :each do
    @thing = build :thing, :resource
  end
  
  it "can have a price and a period" do
    @thing.price.should == "5.00"
    @thing.period.should == "week"
    @thing.should be_valid
  end
  
  it "cannot have just a price" do
    @thing.period = nil
    @thing.should_not be_valid
  end
  
  it "cannot have just a period" do
    @thing.price = nil
    @thing.should_not be_valid
  end
  
  it "should have prices" do
    @thing.should respond_to :prices
  end
  
  it "should have owners" do
    build(:person, things: [@thing]).save
    @thing.owners.size.should == 1
    @thing.owners.first.name.should == 'test person'
    @thing.owners.first.type.should == 'Person'
  end
  
end
