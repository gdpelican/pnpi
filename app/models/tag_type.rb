
class TagType < ActiveRecord::Base
  has_many :tags
  
  def self.search(resource = nil, category = nil, limit = 1000)
    tag_types = TagType.arel_table

    result = resource.blank? ? all
           : filter_arel(tag_types, :resource, resource)
    result = result.filter_arel(tag_types, :category, category) unless category.blank?
    result.joins(:tags).select('name, tags.id, tags.tag').limit(limit).group_by(&:name)
  end
  
  private
  
  scope :filter_arel, ->(table, field, value) { where(table[field].eq(value).or table[field].eq(nil)) }

end
