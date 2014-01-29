class ResourcesController < ApplicationController
  include ResourceHelper
  
  before_action :set_type
  before_action :set_resource, except: :index
  before_action :allow_person_create, only: [:new, :create]
  before_action :set_collections,     only: [:new, :edit, :show]
  before_action :require_admin,       only: [:index, :destroy]
  before_action :require_owner,       only: [:edit, :update]
  before_action :require_user,        only: [:show]
    
  # GET /resources
  # GET /resources.json
  def index
    @scope = (params[:scope] || :all).to_sym
    collection = model.send @scope
    collection.append model.new if @scope == :all
    @resources = decorator.decorate_collection collection
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    redirect_to @resource.sample_url if @resource.sample?
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
        data = handle_successful_creation
        format.html { redirect_to data[:url], notice: data[:notice] }
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
        handle_successful_update
        format.html { redirect_to resource_path(@resource, :edit), notice: 'Changes successfully saved.' }
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
      format.html { redirect_to resource_path(@resource, :index), notice: "#{@resource.name} successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
  
  def set_type
    @type = params[:type].humanize.singularize || 'Resource'
  end
  
  def set_resource
    @resource = decorator.decorate resource
  end
  
  def set_collections
    @categories = Category.filter model.category_type 
    @tags =       TagType.filter  model.to_s.downcase
    @periods =    Thing.periods if @resource.thing? or @resource.person?
    @jobs =       Job.all.map { |job| [job.name, job.id] } if @resource.person? || @resource.sample?
  end
 
  def resource
    case action_name.to_sym
    when :new    then model.new({type: @type}.merge owner_array)
    when :create then model.new(strong_type(params, @type, @type.downcase).merge owner_array)
    else              model.include_children.find params[:id]
    end
  end
  
  def owner_array
    if    params[:person_id] then { owners: [Person.find(params[:person_id])] }
    elsif current_user then       { owners: [current_user.person] }
    else                          {} end
  end
  
  def model
    @type.constantize if @type
  end
  
  def decorator
    "#{model}Decorator".constantize if model
  end
  
  def allow_person_create
    @resource.person? || require_owner
  end

  def require_owner
    handle_auth current_user.present? &&
                @resource.present? &&
               (@resource.person? && @resource.id == current_user.person_id ||
                @resource.owners.include?(current_user.person)), 
                "You must be logged in as #{if @resource.person? then @resource.name else "an owner of this #{@type.downcase}" end } to complete this action."
  end
  
  def handle_successful_creation
    if @resource.person? && !admin? then 
      { url: root_url, notice: "Thanks for submitting! You'll be hearing from us soon, at the email address provided." }
    else                  
      { url: resource_path(@resource, :show), notice: "#{@type} was successfully created" }
    end 
  end
  
  def handle_successful_update
    if @resource.person? && admin? && !User.exists_for?(@resource)
      WelcomeMailer.welcome_email(@resource).deliver
    end  
  end

end