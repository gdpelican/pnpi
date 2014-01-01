class ResourcesController < ApplicationController
  before_action :set_resource, except: :index
  before_action :set_collections, only: [:new, :edit, :show]
  before_action :require_admin, only: [:new, :create, :index, :destroy]
  before_action :require_owner, only: [:edit, :update]
  before_action :require_user,  only: [:show]
    
  # GET /resources
  # GET /resources.json
  def index
    @resources = decorator.decorate_collection model.all
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
  end

  # GET /resources/new
  def new
  end

  # GET /resources/1/edit
  def edit
  end

  # POST /resources
  # POST /resources.json
  def create
    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource.url, notice: 'Resource was successfully created.' }
        format.json { render action: 'show', status: :created, location: @resource }
      else
        format.html { render action: 'new' }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resources/1
  # PATCH/PUT /resources/1.json
  def update
    respond_to do |format|
      if @resource.update strong_type params, @type, @type.downcase
        format.html { redirect_to @resource.url(:edit), notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to @resource.url }
      format.json { head :no_content }
    end
  end

  private
  
  def set_resource
    @type = params[:type]
    @resource = decorator.decorate resource
  end
  
  def set_collections
    @categories = Category.filter model.category_type 
    @tags = TagType.filter  model.to_s.downcase
    @jobs = Job.all
  end
 
  def resource
    case action_name.to_sym
    when :new    then model.new type: @type
    when :create then model.new strong_type params, @type, @type.downcase
    else              model.include_children.find params[:id]
    end
  end
  
  def model
    @type.constantize if @type
  end
  
  def decorator
    "#{model}Decorator".constantize if model
  end

  def require_owner
    handle_auth current_user.present? &&
                @resource.present? &&
               (@resource.person? && @resource.id == current_user.person_id || 
                @resource.owners.include?(current_user.person))
  end

end