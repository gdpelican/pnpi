class SessionsController < Devise::SessionsController
    
  protected
  
  def set_background
    @background = :picture
    @background_shade = :dark
  end
  
end