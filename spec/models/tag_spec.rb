require 'spec_helper'

describe Tag do
  
  before :each do
    @tag = build :tag
  end

  it "should respond to name" do
    @tag.name.should == 'test tag'  
    @tag.should be_valid
  end
  
  it "should have a tag type" do
    @tag.tag_type.name.should == 'test type'
  end
  
  it "should have resources" do
    build(:person, tags: [@tag]).save
    @tag.resources.size.should == 1
    @tag.resources.first.name.should == 'test person'
  end

  it "can search for tags by id" do
    @tag.save
    tags = Tag.search [@tag.id]
    tags.size.should == 1
    tags.first.name.should == 'test tag'
  end
  
end
