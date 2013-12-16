class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  PAGE_SIZE = 15
  
  attr_accessor :term, :do_search, :resource, :category, :tags, :page, :search_term
  
  def initialize(attributes = {})
    attributes.each do |name, value| send("#{name}=", value) end
  end
  
  def as_json(options = {})
    super(options).merge!({ resources: self.resources, categories: self.categories, results: self.results, tag_list: self.tag_list })
  end
  
  def resources
    Resource.types
  end
    
  def categories
    append_blank(Category.filter(resource.humanize.constantize.category_type).sanitize(:name)) if resource.present?
  end
    
  def tag_list
    Tag.filter(resource, category).sanitize(:tag) if search_ready?
  end
  
  def results
    if  filter_search? 
      Resource.search :filter, { resource: resource, category: category, page_size: PAGE_SIZE, page: page || 1, tags: humanized_tags }
    elsif text_search?
      Resource.search :text,   { term: term, page_size: PAGE_SIZE, page: page || 1 }
    end
  end

  private
  
  def humanized_tags
    tags.map { |tag| tag.humanize } if tags.present? and tags.any?
  end
  
  def search_ready?
    resource.present? and category.present?
  end
  
  def filter_search?
    search_ready? and do_search
  end
  
  def text_search?
    term.present? and not filter_search?
  end
  
  def append_blank(array)
    array.unshift({ id: '', name: '' })
  end

end