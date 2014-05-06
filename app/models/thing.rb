class Thing < Resource

  before_validation :set_price_per_period
  before_validation :set_category
  after_initialize :get_price_per_period
  
  validates_with ThingValidator
  
  alias_attribute :prices, :categories 
  
  attr_accessor :price, :period
  
  def set_category
    self.categories = Category.named(if self.price_per_period then :rent else :borrow end)
  end
 
  def set_price_per_period
    return if id.nil? and price_per_period.present? #to allow seeding
    self.price.gsub! '$', '' unless self.price.nil?
    if self.price.to_f > 0 && self.period.present? then self.price_per_period = "#{self.price.to_f} / #{self.period}"
    else                                                self.price_per_period = nil end
  end
  
  def get_price_per_period
    return unless price_per_period
    self.price = price_per_period.split('/')[0].to_f
    self.period = price_per_period.split('/')[1].chomp
  end

  def self.category_type
    'Price'
  end
  
  def self.details
    [:price_per_period, :person_id]  
  end
  
  def self.mass_fields
    super | [:price, :period]
  end
  
  def self.periods
    [:hour, :day, :week, :month, :year].map { |period| ["per #{period}", "#{period}"]}
  end
  
end