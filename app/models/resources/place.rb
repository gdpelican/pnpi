class Place < Resource
  
  has_and_belongs_to_many :people
  alias_attribute :owners, :people
      
  alias_attribute :events, :categories
  
  def self.category_type
    'Event'
  end 
  
  def self.details
    [:latitude, :longitude, :address]
  end
   
end
