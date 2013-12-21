class SearchController < ApplicationController
  respond_to :html, :json
  SEARCHES = [:categories, :tags, :filter, :text]
  
  def initialize
    super
    SEARCHES.each do |action| 
      SearchController.send(:define_method, action) {
        @search = Search.new search_params
        respond_to do |format|
          format.json { render json: @search }
        end
      } 
    end
  end
  
  def new
    @search = Search.new type: :resources
  end
  
  def search_params
    params.except(:controller, :action).merge({ type: action_name })
  end
  
end
