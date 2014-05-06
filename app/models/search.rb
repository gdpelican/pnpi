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
      resources:  Resource.types, 
      categories: Category.search(resource) }.merge(doing_search? ? 
    { results:    Resource.search(search_hash),
      tag_list:   TagType.search(resource, category),
      tags:       tags || [],
      term:       term,
      resource:   resource, 
      category:   category,
      page:       (page || 1).to_i,
      max_page:   max_page } : {})
  end

  private
    
  def max_page
    [((Resource.count(search_hash) - 1) / PAGE_SIZE) + 1, 1].max
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

  def doing_search?
    [:filter, :text, :all].include? type.to_sym
  end
  
end