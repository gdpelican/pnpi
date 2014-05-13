class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  PAGE_SIZE = 5
  
  attr_accessor :type, :term, :tags, :resource, :category, :page
  
  def initialize(attributes = {})
    attributes.each do |name, value| send("#{name}=", value) end
  end
  
  def as_json(options = {})
    { type:       type,
      resources:  resources, 
      categories: categories }.merge(resource_search? ? 
    { results:    results,
      tag_list:   tag_list,
      tags:       tags || [],
      term:       term,
      resource:   resource, 
      category:   category,
      page:       (page || 1).to_i,
      max_page:   max_page } : {})
  end
  
  def resources
    Resource.types
  end
  
  def categories
    Category.search resource
  end
  
  def results
    SearchService.search search_hash
  end
  
  def tag_list
    TagType.search resource, category
  end
  
  def resource_search?
    [:filter, :text, :all].include? type.to_sym
  end
  
  def cache_key
    return unless resource_search?
    result = "#{type}_"
    result += case type.to_sym
      when :filter then "#{resource}_#{category}_"
      when :text then "#{term}_"
      else "" end
    result += "#{page || 1}#{"_[#{tags.join(',')}]" if tags.present?}"
    result.downcase
  end

  private
    
  def max_page
    [((SearchService.count(search_hash) - 1) / PAGE_SIZE) + 1, 1].max
  end
  
  def search_hash
    { search: type.to_sym, 
      resource: resource, 
      category: category, 
      term: term,
      tags: tags,
      page_size: PAGE_SIZE, 
      page: page }
  end
  
end