class RegistrationsController < Devise::RegistrationsController
  
  before_action :require_token, only: [:new, :create]
  
  protected
  
  def build_resource(hash=nil)
    super(hash)
    self.resource.person = @person if @person
  end

  protected
  
  def set_background
    @background = :picture
    @background_shade = :dark
  end

  private
   
  def require_token
    @person = Person.find(params[:id])
    handle_auth(!User.exists_for?(@person), 'This account has already been registered! Please sign in with your password to continue.') ||
    handle_auth(@person.signup_token == params[:signup_token], 'Please provide the token sent with your signup email to complete registration')
  end
  
end