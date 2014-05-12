class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_background

  def strong_type(params, model = nil, param_name = nil, require_nest = true)
    model ||= controller_name
    param_name ||= model
    params = params.require(param_name) if require_nest
    params.permit("#{model}".classify.constantize.mass_fields)
  end
  
  def font_icon(icon)
    "<i class=\"icon-#{icon}\"></i>".html_safe
  end
  
  protected
  
  def initialize
    super
    @user = User.new
  end
      
  def require_admin
    handle_auth false, 'You must be an admin to complete this action.'
  end
    
  def require_user
    handle_auth current_user.present?, 'You must be logged in to complete this action'
  end
  
  def require_non_user
    handle_auth current_user.blank?, 'You are already logged in'
  end
  
  protected

  def set_background
    @background = :texture
    @background_shade = :light
  end
  
  private
  
  def admin?
    current_user.present? and current_user.admin?
  end
  
  def handle_auth(condition, message)
    flash[:alert] = message and redirect_to root_url unless condition or admin?
  end
  
end