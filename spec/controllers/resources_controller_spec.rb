require 'spec_helper'

describe ResourcesController do
 
  let(:app_controller) { controller }
  let(:user) {  create :user, person_id: create(:person, :resource).id }
  let(:admin) { create :user, person_id: create(:person, :resource).id, admin: true }
 
  before do
    Paperclip::Attachment.any_instance.stub(:save).and_return true    
    WelcomeMailer.any_instance.stub(:welcome_email).and_return true
  end
        
  context "admin authentication" do
    before do
      app_controller.stub(:current_user).and_return admin
    end
    
    it "can access the create route" do
      post :create, type: 'Person', person: { name: 'test', description: 'description', email: 'wark@wark.com', website: 'http://www.example.com' }
      resource = assigns(:resource)
      resource.should be_valid
      response.should redirect_to person_url resource      
    end
    
    it "can access the index route" do
      get :index, type: 'Place'
      response.should render_template :index
    end
    
    it "can access the update route" do
      person = create :person, :resource
      post :update, id: person.id, type: 'Person', person: { website: 'http://www.wark.com' }
      person.reload.website.should eq 'http://www.wark.com'
      resource = assigns(:resource)
      response.should redirect_to edit_person_path resource  
    end
    
    it "can access the destroy route" do
      sample = create :sample, :resource
      post :destroy, type: 'Sample', id: sample.id
      response.should redirect_to samples_path      
    end
    
  end
  
  context "user authentication" do
    before do
      app_controller.stub(:current_user).and_return user
    end
    
    it "can access the show route" do
      thing = create :thing, :resource
      get :show, type: 'Thing', id: thing.id
      response.should render_template :show
    end
    
    it "can access its own edit route" do
      get :edit, type: 'Person', id: user.person.id
      response.should render_template :edit
    end
    
    it "cannot access another's edit route" do
      person = create :person, :resource
      get :edit, type: 'Person', id: person.id
      response.should redirect_to root_url
    end
    
    it "can access the new thing route" do
      get :new, type: 'Thing'
      response.should render_template :new
    end
    
    it "cannot access the new person route" do
      get :new, type: 'Person'
      response.should redirect_to root_url
    end
    
  end
  
  context "non-user authentication" do
    before do
      app_controller.stub(:current_user).and_return nil
    end
    
    it "cannot access the show route" do
      thing = create :thing, :resource
      get :show, type: 'Thing', id: thing.id
      response.should redirect_to root_url
    end
    
    it "cannot access the edit route" do
      place = create :place, :resource
      get :edit, type: 'Place', id: place.id
      response.should redirect_to root_url
    end
    
    it "can access the new person route" do
      get :new, type: 'Person'
      response.should render_template :new
    end
    
    it "cannot access the new thing route" do
      get :new, type: 'Thing'
      response.should redirect_to root_url
    end
    
  end
  
  context "skip authentication" do
    before do
      app_controller.stub(:handle_auth).and_return true
      app_controller.stub(:current_user).and_return User.new
    end
    
    describe "show route" do
      it "shows a requested person" do
        person = create :person, :resource
        get :show, id: person.id, type: 'Person'
        assigns(:resource).should eq(person)
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
    end
    
    describe "new route" do
      it "can show a new thing" do
        get :new, type: 'Thing'
        response.should render_template :new
        assigns(:resource).id.should be_nil
      end
    end
    
    describe "edit route" do
      it "can edit a place" do
        place = create :place, :resource
        get :edit, type: 'Place', id: place.id
        response.should render_template :edit
        assigns(:resource).should eq(place)
      end
    end
    
    describe "create route" do
      it "can create a person" do
        post :create, type: 'Person', person: { name: 'test', description: 'description', email: 'wark@wark.com', website: 'http://www.example.com' }
        assigns(:resource).should be_valid
        response.should redirect_to root_url  
      end
      
      it "can create a thing" do
        owner = create :person, :resource
        post :create, type: 'Thing', thing: { name: 'thing', description: 'description', owner_ids: [owner.id] }
        resource = assigns(:resource)
        resource.should be_valid
        response.should redirect_to thing_url(resource)
      end
      
      it "does not create an invalid place" do
        post :create, type: 'Place', place: { description: 'description' }
        assigns(:resource).should_not be_valid
        response.should render_template :new
      end
    end
    
    describe "update route" do
      it "can update a person's details" do
        person = create :person, :resource
        post :update, id: person.id, type: 'Person', person: { website: 'http://www.wark.com' }
        person.reload.website.should eq 'http://www.wark.com'
      end
        
      it "can update a thing" do
        thing = create :thing, :resource
        post :update, id: thing.id, type: 'Thing', thing: { name: 'New thing name' }
        thing.reload.name.should eq 'New thing name'
      end
      
      it "can activate a place" do
        place = create :place, :resource, active: false
        post :update, id: place.id, type: 'Place', place: { active: true }
        place.reload.active.should eq true
      end
      
      it "does not update an invalid sample" do
        sample = create :sample, :resource
        post :update, id: sample.id, type: 'Sample', sample: { name: 'bo' }
        response.should render_template :edit
      end
    end
    
    describe "destroy route" do
      it "can destroy a person" do
        person = create :person, :resource
        post :destroy, id: person.id, type: 'Person'
        resource = assigns(:resource).should eq person
        response.should redirect_to people_path
      end
    end
    
  end
  
end
