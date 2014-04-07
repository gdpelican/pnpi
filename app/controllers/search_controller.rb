class SearchController < ApplicationController
  respond_to :html, :json
  SEARCHES = [:categories, :filter, :text, :all]
  before_action :populate_types
  before_action :populate_search, except: :new
  
  def new
    @search = Search.new type: :new
  end
  
  protected
  
  def initialize
    super
    SEARCHES.each do |action| 
      SearchController.send(:define_method, action) {
        respond_to do |format|
          format.html { render template: 'search/new' }
          format.json { render json: @search }
        end
      }
    end
  end
  
  def set_background
    super
    @background_shade = :dark
  end
  
  private

  def populate_types
    @types = Resource.types
  end

  def populate_search
    cookies[:last_search] = { value: request.original_url, expires: 1.hour.from_now }
    @search = Search.new search_params
  end
  
  def search_params
    params.except(:controller, :action, :format).merge({ type: action_name })
  end
  
end
