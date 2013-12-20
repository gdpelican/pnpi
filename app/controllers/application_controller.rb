class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def strong_type(params, model = nil, param_name = nil)
    model ||= controller_name
    param_name ||= model
    params.require(param_name).permit(model.to_s.classify.constantize.mass_fields)
  end
  
  def font_icon(icon)
    "<i class=\"icon-#{icon}\"></i>".html_safe
  end
  
  def boot_to_root(condition = false, message = 'You must be logged in to complete this action')
    redirect_to root_url, alert: message unless condition or admin?
  end
  
  private
  
  def admin?
    current_user.present? and current_user.admin?
  end
  
end
