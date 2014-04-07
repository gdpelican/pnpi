class Category < ActiveRecord::Base
  
  has_and_belongs_to_many :resources   
   
  validates :name, length: { minimum: 3 }
  validates :type, inclusion: { in: ['Job', 'Event', 'Price'] }
 
  scope :named, ->(name) { where(name: name.to_s.humanize) }
  scope :filter, ->(type) { where(type: type) }
  scope :exclude, ->(type) { where('type <> ?', type.to_s.humanize) }

  def self.search(resource)
    return [] unless resource.present?    
    filter(resource.to_s.humanize.constantize.category_type)
      .sanitize(:name)
      .unshift({ id: '', name: ''})
  end

  def self.mass_fields
    [:name, :type]
  end

end
