class GroupingsController < ApplicationController
  respond_to :html, :json

  before_action :require_admin
  before_action :set_type
  before_action :set_groupings, only: :index

  def index
  end
  
  def create
    handle_response model.create(strong_type params, model, nil, false)  
  end

  def update
    handle_response model.find(params[:id]).update_attribute(:name, params[:name])
  end
  
  def destroy
    handle_response model.find(params[:id]).destroy
  end
  
  protected
  
  def handle_response(success = true)
    message = "#{@type} #{success ? 'successfully' : 'unable to be'} #{action_name}ed".squeeze('e')
    respond_to do |format|
      format.json { render json: { action: action_name, 
                                   message: message, 
                                   success: success.blank?, 
                                   partial: (action_name == 'create') ? render_to_string(partial: '/groupings/grouping', locals: { group: success }, formats: [:html]) : '' } }
    end
  end
  
  def set_type
    @type = (params[:type]).downcase.to_sym
  end
  
  def set_groupings
    @groupings = case @type
    when :category then Category.exclude(:price).group_by(&:type)
    when :tag then      TagType.joins(:tags).uniq.group_by(&:resource)
    else nil end
  end
  
  def model
    "#{@type}".classify.constantize
  end
  
end
