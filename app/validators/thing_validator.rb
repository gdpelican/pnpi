class ThingValidator < ActiveModel::Validator
  def validate(thing)
    thing.errors[:base] << price_fields_error if price_fields_mismatch?(thing) 
  end
  
  private
  
  def price_fields_error
    'Must specify both a price and a period (leave both blank to allow it to be borrowed free of charge)'
  end
  
  def price_fields_mismatch?(thing)
    thing.period.nil? != thing.price.nil?
  end 
  
end