class Thing < Resource

  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  before_validation :set_category
  after_find :remove_empty_price
  
  alias_attribute :prices, :categories 

  def set_category
    self.categories = Category.named(if zero_price? then :borrow else :rent end)
  end

  def self.category_type
    'Price'
  end
  
  def self.details
    [:price, :person_id]  
  end
  
  private
  
  def remove_empty_price
    price = nil if price == 0
  end
  
  def zero_price?
    price.nil? || price.to_i == 0
  end
  
end