class ThingDecorator < ResourceDecorator
  include ActionView::Helpers::NumberHelper

  delegate_all
  
  def category_message
    "This is item is available to #{categories.first.name}" if categories.any?
  end
  
  def price
    number_to_currency object.price
  end
  
  def details
    [{ text: price_per_period, icon: 'dollar' }]
  end

end
