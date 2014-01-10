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
  
  def tags?
    tags.any?
  end
  
  def unsaved?
    object.id.nil?
  end
  
  def inactive?
    not object.active
  end
  
  def tags(append = false)
    collection :tags, append
  end
  
  def owners(append = false)
    collection :owners, append
  end
    
  def category_type
    object.class.category_type.pluralize
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
    collection = collection.to_a.push field.to_s.singularize.humanize.constantize.new if append
    PossessionDecorator.decorate_collection collection
  end
  
end