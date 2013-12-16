class Tag < ActiveRecord::Base
  has_and_belongs_to_many :resources
  
  def self.filter(resource, category = nil)
    tags = Tag.arel_table
    result = where(tags[:resource].eq(resource).or tags[:resource].eq(nil))
    result = result.where(tags[:category].eq(category).or tags[:category].eq(nil)) unless category.nil?
    result.uniq
  end
  
end
