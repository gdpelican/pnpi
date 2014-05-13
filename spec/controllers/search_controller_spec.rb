require 'spec_helper'

describe SearchController do
  
  before :each do
    Paperclip::Attachment.any_instance.stub(:save).and_return true
    @tag1 = create :tag
    @actor = create :job, name: 'Actor'
    @director = create :job, name: 'Director'
    @person1 = create :person, :resource, jobs: [@actor], tags: [@tag1]
    @person2 = create :person, :resource, jobs: [@actor, @director], description: 'wark desc'
    @person3 = create :person, :resource, jobs: [@director]
    @thing1 = create :thing, :resource, name: 'wark title'
  end
  
  it "can return a search result in html" do
    get :all, format: :html
    response.should render_template :new
  end
  
  #it "can return a search result in json" do
  #  get :all, format: :json
  #  raise response[:results].to_s
  #end
  
  context "filter searching" do
    it "can find a record by resource and category" do
      get :filter, resource: 'Person', category: :actor
      search = assigns(:search)
      search.results.should include(@person1)
      search.results.should include(@person2)
    end
    
    it "does not find records without the given resource" do
      get :filter, resource: 'Person', category: :director
      assigns(:search).results.should_not include(@thing1)       
    end
    
    it "does not find records without the given category" do
      get :filter, resource: 'Person', category: :director
      assigns(:search).results.should_not include(@person1)
    end
    
  end
  
  context "term searching" do
    it "can find a record by name" do
      get :text, term: 'wark'
      assigns(:search).results.should include(@thing1)
    end
    
    it "can find a record by description" do
      get :text, term: 'wark'
      assigns(:search).results.should include(@person2)
    end
    
    it "does not find records which do not match given term" do
      get :text, term: 'wark'
      assigns(:search).results.should_not include(@person1)
    end
    
    it "finds all records when matching a wildcard" do
      get :text, term: '*'
      assigns(:search).results.should have(Resource.count).items
    end
    
  end
  
  context "searching categories" do
    it "can find categories for a given resource" do
      get :categories, resource: 'Person'
      categories = assigns(:search).categories.map { |c| c[:name] }
      categories.should include(@actor.name)
      categories.should include(@director.name)
    end
  end
  
  context "searching all records" do
    it "can find all records" do
      get :all
      search = assigns(:search)
      search.results.should have(Resource.count).items
      search.results.should include(@person1)
      search.results.should include(@thing1)
    end
  end
    
  context "tag searching" do
    it "can search for records with tags" do
      get :all, tags: [@tag1.id]
      search = assigns(:search)
      search.results.should include(@person1)
    end
    
    it "does not return results which do not have tags" do
      get :all, tags: [@tag1.id]
      search = assigns(:search)
      search.results.should_not include(@person2)    
    end
  end
  
  context "last search storage" do
    it "stores the last performed search" do
      get :filter, resource: 'Person', category: :actor
      cookies[:last_search].should eq 'filter_person_actor_1'
      
      get :text, term: 'wark'
      cookies[:last_search].should eq 'text_wark_1'
      
      get :all
      cookies[:last_search].should eq 'all_1'
    end
    
    it "stores the last performed search with tags" do
      get :filter, resource: 'Person', category: :actor, tags: [@tag1]
      cookies[:last_search].should eq "filter_person_actor_1_[#{@tag1.id}]"
    end
    
  end
  
end
