class ResourceDecorator < Draper::Decorator
  delegate_all
  
  def person?
    type == 'Person'
  end
  
  def place?
    type == 'Place'
  end
  
  def thing?
    type == 'Thing'
  end
  
  def category_type
    object.class.category_type.pluralize
  end

end
