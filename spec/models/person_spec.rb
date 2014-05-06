require 'spec_helper'

describe Person do
  
  before :each do
    @person = build :person, :resource
  end
  
  it "should have an email" do
    @person.email.should == 'test@email.com'
    @person.should be_valid
  end
  
  it "can have a website" do
    @person.website = nil
    @person.should be_valid
  end
  
  it "can have a phone number" do
    @person.phone.should == '555 555 5555'
    @person.phone = nil
    @person.should be_valid
  end
  
  it "should construct a name when it is saved" do
    @person.save!
    @person.name.should == 'test person'
  end
    
  it "should append http:// to its website when saved" do
    @person.save!
    @person.reload.website.should == 'http://www.example.com'
  end
  
  it "should have jobs" do
    @person.should respond_to :jobs
  end
  
  it "should have places" do
    @person.should respond_to :places
  end
  
  it "should have things" do
    @person.should respond_to :things
  end
  
  it "should have samples" do
    @person.should respond_to :samples
  end
  
  it "can generate a signup token" do
    @person.generate_signup_token.length.should == 10
  end
  
end
