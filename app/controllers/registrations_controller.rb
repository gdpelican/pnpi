class RegistrationsController < Devise::RegistrationsController
  
  before_action :require_token, only: [:new, :create]
  
  protected
  
  def build_resource(hash=nil)
    super(hash)
    self.resource.person = Person.find(params[:id]) if params[:id]
  end

  protected
  
  def set_background
    @background = :picture
  end

  private
   
  def require_token
    build_resource sign_up_params
    handle_auth !self.resource.person.active, 'This account has already been registered! Please sign in with your password to continue.'
    handle_auth self.resource.person.signup_token == params[:signup_token], 'Please provide the token sent with your signup email to complete registration'
  end
  
end