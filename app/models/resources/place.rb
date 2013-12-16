class Place < Resource
    
  alias_attribute :events, :categories
  
  def self.category_type
    'Event'
  end 
  
  def self.details
    [:latitude, :longitude, :address]
  end
   
end
