class Person < Resource
  alias_attribute :jobs, :categories  
  attr_accessor :first_name, :last_name
      
  after_initialize :get_name
  before_validation :set_name
  
  has_many :skills, foreign_key: :resource_id
  
  def get_name
    self.first_name, self.last_name = self.name.split(' ')[0], self.name.split(' ')[1] if self.name
  end
  
  def set_name
    self.name = "#{first_name} #{last_name}" if first_name.present? and last_name.present?
  end
  
  def self.category_type
    'Job'
  end
  
  def self.details
    [:email, :phone]
  end
  
  def self.mass_fields
    super | [:first_name, :last_name]
  end
  
end
