class Tag < ActiveRecord::Base
  has_and_belongs_to_many :resources
  belongs_to :tag_type
  
  alias_attribute :name, :tag
  
  scope :search, ->(values) { where('id IN (?)', values) }
  
  def self.mass_fields
    [:name, :tag_type_id]
  end
end
