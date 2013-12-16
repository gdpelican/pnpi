class Skill < ActiveRecord::Base
  self.table_name = 'categories_resources'
  
  belongs_to :category
  belongs_to :resource
  has_many :samples, foreign_key: :categories_resource_id
  
  validates :resource, :category, presence: true
  
  default_scope { joins(:resource).where('resources.type = ?', 'Person').references(:resource) }
  
  alias_attribute :person_id, :resource_id
    
end