class Category < ActiveRecord::Base
  
  has_and_belongs_to_many :resources   
   
  validates :name, length: { minimum: 3 }
  validates :type, inclusion: { in: ['Job', 'Event', 'Price'] }
 
  scope :named, ->(name) { where(name: name.to_s.humanize) }
  scope :filter, ->(type) { where(type: type) }

end
