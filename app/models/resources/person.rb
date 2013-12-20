class Person < Resource
  alias_attribute :jobs, :categories  
  attr_accessor :first_name, :last_name
  
  has_and_belongs_to_many :possessions, 
    class_name:              'Resource',
    join_table:              :owners_possessions,
    association_foreign_key: :possession_id,
    foreign_key:             :owner_id
                                        
  after_initialize :get_name
  before_validation :prepare_for_save
  
  validates :email, presence: true
  has_many :skills, foreign_key: :resource_id
  
  def get_name
    self.first_name, self.last_name = self.name.split(' ')[0], self.name.split(' ')[1] if self.name
  end
  
  def prepare_for_save
    self.name = "#{first_name} #{last_name}" if first_name.present? and last_name.present?
    self.email = self.email.downcase
  end
  
  def self.category_type
    'Job'
  end
  
  def self.find_by_email(email)
    Person.where(Person.arel_table[:details].matches("%#{email.downcase}%")).first
  end
  
  def self.details
    [:email, :phone]
  end
  
  def self.mass_fields
    super | [:first_name, :last_name]
  end
  
end