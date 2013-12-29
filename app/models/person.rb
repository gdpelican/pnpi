class Person < Resource
  alias_attribute :jobs, :categories  
  attr_accessor :first_name, :last_name
    
  has_and_belongs_to_many :places, 
    class_name:              'Place',
    join_table:              :owners_possessions,
    association_foreign_key: :possession_id,
    foreign_key:             :owner_id
  has_and_belongs_to_many :things,
    class_name:              'Thing',
    join_table:              :owners_possessions,
    association_foreign_key: :possession_id,
    foreign_key:             :owner_id
  has_many :samples
      
  accepts_nested_attributes_for :places, reject_if: :all_blank, allow_destroy: :true
  accepts_nested_attributes_for :things, reject_if: :all_blank, allow_destroy: :true
  accepts_nested_attributes_for :samples, reject_if: :all_blank, allow_destroy: :true
                                        
  after_initialize :get_name
  before_validation :prepare_for_save
  
  validates :email, presence: true
  
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
    super | [:first_name, 
             :last_name,      
             places_attributes: Place.mass_fields,
             things_attributes: Thing.mass_fields,
             samples_attributes: Sample.mass_fields]
  end
  
end