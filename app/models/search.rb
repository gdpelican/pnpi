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
    { type: type, results: results }.merge(doing_search? ? { page: page.to_i, max_page: max_page } : {})
  end
  
  def results
    case type.to_sym
    when :resources     then Resource.types
    when :categories    then append_blank(Category.filter(category_type).sanitize(:name)) if resource.present?
    when :tags          then Tag.filter(resource, category).sanitize(:tag)                if tag_ready?
    when :text, :filter then Resource.search(search_hash)                                 if search_ready?
    end
  end
  
  def max_page
    ((Resource.count(search_hash) - 1) / PAGE_SIZE) + 1
  end

  private
  
  def category_type
    resource.humanize.constantize.category_type if resource.present?
  end
 
  def append_blank(array)
    array.unshift({ id: '', name: '' })
  end
   
  def humanized_tags
    tags.map { |tag| tag.humanize } if tags.present? and tags.any?
  end
  
  def search_hash
    hash = case type.to_sym
    when :filter then { search: :filter, resource: resource, category: category, tags: humanized_tags }
    when :text   then { search: :text, term: term } 
    else                    { search: :unknown } 
    end
    hash.merge({ page_size: PAGE_SIZE, page: page || 1 })
  end
  
  def doing_search?
    [:filter, :text].include? type.to_sym
  end
  
  def search_ready?
    tag_ready? || text_search?
  end  
  
  def tag_ready?
    resource.present? and category.present?
  end
  
  def text_search?
    term.present? and not tag_ready?
  end
  
  def append_blank(array)
    array.unshift({ id: '', name: ''})
  end

end