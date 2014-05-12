require 'spec_helper'
require 'pry'

describe ResourcesController do
 
  let(:app_controller) { controller }
  
  context "skip authentication" do
    before do
      Paperclip::Attachment.any_instance.stub(:save).and_return true
      app_controller.stub(:handle_auth).and_return true
      app_controller.stub(:current_user).and_return true
    end
    
    describe "show route" do
      it "shows a requested person" do
        person = create :person, :resource
        get :show, id: person.id, type: 'Person'
        assigns(:resource).should eq(person)
        response.should render_template 'show' 
      end
      
      it "shows a requested place" do
        place = create :place, :resource
        get :show, id: place.id, type: 'Place'
        assigns(:resource).should eq(place)
        response.should render_template 'show'
      end
      
      it "shows a requested thing" do
        thing = create :thing, :resource
        get :show, id: thing.id, type: 'Thing'
        assigns(:resource).should eq(thing)
        response.should render_template 'show' 
      end
      
      it "shows a requested sample" do
        sample = create :sample, :resource
        get :show, id: sample.id, type: 'Sample'
        assigns(:resource).should eq(sample)
        response.should redirect_to sample.picture.url
      end
    
    end
    
    describe "index route" do
      it "lists all people" do
        person1 = create :person, :resource
        person2 = create :person, :resource
        get :index, type: 'Person'
        assigns(:scope).should eq(:all)

        resources = assigns(:resources)
        resources.should(include(person1))
        resources.should(include(person2))
        # we append a Person.new on the end of the :all scope, so admins can add new records
        resources.should(have(3).items)    
                  
        response.should render_template 'index'
      end
      
      it "lists all places" do
        place1 = create :place, :resource
        place2 = create :place, :resource
        get :index, type: 'Place'
        assigns(:scope).should eq(:all)

        resources = assigns(:resources)
        resources.should(include(place1))
        resources.should(include(place2))
        # we append a Place.new on the end of the :all scope, so admins can add new records
        resources.should(have(3).items)    
           
        response.should render_template 'index'
      end
      
      it "lists all things" do
        thing1 = create :thing, :resource
        thing2 = create :thing, :resource
        get :index, type: 'Thing'
        
        resources = assigns(:resources)
        resources.should(include(thing1))
        resources.should(include(thing2))
        # we append a Thing.new on the end of the :all scope, so admins can add new records
        resources.should(have(3).items)    
                  
        response.should render_template 'index'
      end
      
      it "lists all samples" do
        sample1 = create :sample, :resource
        sample2 = create :sample, :resource
        get :index, type: 'Sample'
        assigns(:scope).should eq(:all)
        
        resources = assigns(:resources)
        resources.should(include(sample1))
        resources.should(include(sample2))
        # we append a Thing.new on the end of the :all scope, so admins can add new records
        resources.should(have(3).items)    
            
        response.should render_template 'index'
      end      
    end
    
  end
  
end
