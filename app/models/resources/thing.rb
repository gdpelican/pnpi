class Thing < Resource
  belongs_to :person

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  
  before_validation :set_category
  
  alias_attribute :prices, :categories 

  def set_category
    self.price = 0 if self.price.nil? || self.price.empty?
    self.categories = Category.named(if self.price.to_i == 0 then :borrow else :rent end)
  end

  def self.category_type
    'Price'
  end
  
  def self.details
    [:price, :person_id]  
  end
  
end