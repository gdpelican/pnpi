class SearchController < ApplicationController
  respond_to :html, :json
  SEARCHES = [:categories, :filter, :text, :all]
  before_action :populate_search, except: :touch
  
  def new
  end
  
  def touch
    set_last_search_cookie
    render nothing: true
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

  def populate_search
    @types = Resource.types
    @search = Search.new search_params
  end
  
  def search_params
    if action_name == 'new'
      { type: :new }
    else
      params.except(:controller, :action, :format, :cache_key).merge({ type: action_name })      
    end
  end
  
  def set_last_search_cookie
    cookies[:last_search] = { value: params[:cache_key], expires: 1.hour.from_now } if params[:cache_key]
  end
  
end
