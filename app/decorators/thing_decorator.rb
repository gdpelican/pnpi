class ThingDecorator < ResourceDecorator
  delegate_all
  
  def category_message
    "This is item is available to #{categories.first.name}" if categories.any?
  end

end
