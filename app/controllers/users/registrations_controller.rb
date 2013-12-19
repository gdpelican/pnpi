class RegistrationsController < Devise::RegistrationsController
  before_filter :set_person, only: [:new, :edit]
  
  def new
    super
  end
  
  def create
    super
  end
  
  def edit
    super
  end
  
  def update
    super
  end
  
  def cancel
    super
  end
  
  def build_resource(hash=nil)
    super
    self.resource.resource = @person if @person
  end
  
  def set_person
    @person = Person.find(params[:id])
  end
  
end
