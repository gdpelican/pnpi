class Tag < ActiveRecord::Base
  has_and_belongs_to_many :resources
  belongs_to :tag_type
  
  alias_attribute :name, :tag

  def self.map_json(tags)
    Hash(tags).keys.map { |key| tags[key] }
  end  
  
  def self.mass_fields
    [:name, :tag_type_id]
  end
end
