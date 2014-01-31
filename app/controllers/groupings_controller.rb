class GroupingsController < ApplicationController
  respond_to :html, :json

  before_action :require_admin
  before_action :set_type
  before_action :set_groupings, only: :index

  def index
  end
  
  def create
    params[:tag_type_id] = TagType.where(name: params[:tag_type_name]).pluck(:id).first if params[:tag_type_name]
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
                                   partial: (action_name == 'create') ? render_to_string(partial: partial_name, 
                                            locals: { group: success, field: :tags, type: success.tag_type.resource }, formats: [:html]) : '' } }
    end
  end
  
  private
  
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
  
  def partial_name
    case params[:origin].downcase.to_sym
    when :groupings then 'groupings/grouping'
    when :resources then 'resources/forms/tag' 
    end
  end
  
end
