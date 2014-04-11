class TagsController < ApplicationController
  respond_to :json

  def show
    @tag = Tag.find(params[:id])
    respond_to do |format|
      format.json { render json: @tag.as_json(only: [:id, :tag]).merge({ type: 'tags' }) }
    end
  end
  
end
