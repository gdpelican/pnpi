class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  PAGE_SIZE = 5
  
  attr_accessor :type, :term, :resource, :category, :tags, :page
  
  def initialize(attributes = {})
    attributes.each do |name, value| send("#{name}=", value) end
  end
  
  def as_json(options = {})
    { resources: Resource.types, 
      categories: filtered_categories,
      type: type, 
      results: results }.merge(doing_search? ? 
    { term: term, 
      resource: resource, 
      category: category, 
      tags: tags,
      page: (page || 1).to_i, 
      max_page: max_page } : {})
  end
  
  def results
    case type.to_sym
    when :categories          then filtered_categories          if resource.present?
    when :tags                then sanitized_tags               if resource.present? and category.present?
    when :text, :filter, :all then Resource.search search_hash
    end
  end
  
  def max_page
    ((Resource.count(search_hash) - 1) / PAGE_SIZE) + 1 if doing_search?
  end

  private
  
  def category_type
    resource.humanize.constantize.category_type if resource.present?
  end
  
  def filtered_categories
    Category.filter(category_type).sanitize(:name).unshift({ id: '', name: ''})
  end
  
  def search_hash
    { search: type.to_sym, 
      resource: resource, 
      category: category, 
      term: term, 
      tags: humanized_tags, 
      page_size: PAGE_SIZE, 
      page: page || 1 }
  end 
  
  def humanized_tags
    tags.map { |tag| tag.humanize } if tags.present?
  end
  
  def sanitized_tags
    TagType.filter(resource, category).map { |type| { name: type[0], tags: type[1].map { |tag| { name: tag.tag, value: tag.id } } } }
  end
  
  def doing_search?
    [:filter, :text, :all].include? type.to_sym
  end
  
end