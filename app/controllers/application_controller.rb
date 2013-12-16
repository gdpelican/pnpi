class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def strong_type(params, model = nil, param_name = nil)
    model ||= controller_name
    param_name ||= model
    params.require(param_name).permit(model.to_s.classify.constantize.mass_fields)
  end
  
end
