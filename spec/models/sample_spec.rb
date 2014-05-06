require 'spec_helper'

describe Sample do
  
  before :each do
    Paperclip::Attachment.any_instance.stub(:save).and_return true
    @sample = build :sample, :resource
  end
  
  it "should have an attachment" do
    @sample.picture_file_name.should eq 'missing_person.png'
    @sample.should be_valid
  end
  
  
  it "should have owners" do
    build(:person, samples: [@sample]).save
    @sample.owners.should have(1).items
    @sample.owners.first.name.should eq 'test person'
    @sample.owners.first.type.should eq 'Person'
  end
  
end
