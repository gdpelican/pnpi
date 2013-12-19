class RegistrationsController < Devise::RegistrationsController
  
  def build_resource(hash=nil)
    super(hash)
    self.resource.resource = Person.find(params[:id]) if params[:id]
  end
  
end
