class TagType < ActiveRecord::Base
  has_many :tags
  
  def self.filter(resource, category = nil)
    tag_types = TagType.arel_table
    result = where(tag_types[:resource].eq(resource).or tag_types[:resource].eq(nil))
    result = result.where(tag_types[:category].eq(category).or tag_types[:category].eq(nil)) unless category.nil?
    result.joins(:tags).select('name, tags.id, tags.tag').group_by(&:name)
  end 
   
end
