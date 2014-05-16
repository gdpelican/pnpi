class ResourceDecorator < Draper::Decorator
  delegate_all
  
  def type_symbol
    type.downcase.to_sym
  end
  
  def person?
    type_symbol == :person
  end
  
  def place?
    type_symbol == :place
  end
  
  def thing?
    type_symbol == :thing
  end
  
  def sample?
    type_symbol == :sample
  end
  
  def tags?
    tags.any?
  end
  
  def unsaved?
    object.id.nil?
  end
  
  def inactive?
    not object.active
  end
  
  def file_url(size = :thumb)
    object.picture.url(size)
  end
  
  def max_categories
    object.class.max_categories || 1000
  end
  
  def max_tags
    object.class.max_tags || 1000
  end
  
  def owners(append = false)
    collection :owners, append
  end
  
  def category_type
    object.class.category_type.pluralize
  end

  def error_messages
    'Please correct the following errors:<ul>' + 
      errors.map { |key, value| "<li>#{key.to_s.humanize} #{value}</li>" }.uniq.join + 
    '</ul>'
  end
  
  def description_header
    'Description'
  end
  
  def owner_header
    'Contact Info'
  end
 
  private

  def collection(field, append)
    collection = object.send(field)
    field = :people if field == :owners
    
    collection = collection.to_a.push field.to_s.singularize.humanize.constantize.new if append
    collection_model(field).decorate_collection collection
  end
  
  def collection_model(field)
    "#{field.to_s.singularize.humanize}Decorator".constantize
  end
  
end