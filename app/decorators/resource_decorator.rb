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
  
  
  def category_message
    "This is item is available to #{categories.first.name}" if thing? and categories.any?
  end

end
