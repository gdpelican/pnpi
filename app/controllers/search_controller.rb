class SearchController < ApplicationController
  respond_to :html, :json
  
  def new
    @search = Search.new
  end
  
  def update
    @search = Search.new({ resource: params[:resource],
                           category: params[:category], 
                           page: params[:page] || 1,
                           tags: params[:tags],
                           term: params[:term],
                           do_search: params[:do_search] == 'true'})
    respond_to do |format|
      format.json { render json: @search }
    end
  end
  
end
