require 'spec_helper'

describe Resource do
  
  before :each do
    @resource = build :place, :resource
  end
  
  it "has a name, type, preview, and description" do
    @resource.name.should =~ /test name/
    @resource.preview.should eq 'preview'
    @resource.description.should eq 'description'
    @resource.type.should eq 'Place'
    @resource.should be_valid
  end
  
  it "has a name greater than 3 characters" do
    @resource.name = 'Bo'
    @resource.should_not be_valid
  end
  
  it "has a preview less than 140 characters" do
    @resource.preview = 'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG' +
                        'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG' +
                        'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG' +
                        'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
    @resource.should_not be_valid
  end
  
  it "has a maximum number of categories" do
    @resource.categories = (Resource.max_categories + 1).times.map { Category.new }
    @resource.should_not be_valid
  end
  
  it "has a maximum number of tags" do
    max_tags = Resource.max_tags
    @resource.tags = (Resource.max_tags + 1).times.map { Tag.new }
    @resource.should_not be_valid
  end
  
  it "can accept details" do
    @resource.should respond_to :details
  end

end
