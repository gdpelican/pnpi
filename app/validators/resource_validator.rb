class ResourceValidator < ActiveModel::Validator
  MAX_CATEGORIES = 3
  MAX_TAGS = 7
  
  def validate(resource)
    resource.errors[:categories] << category_count_error(resource) if resource.categories.size > MAX_CATEGORIES
    resource.errors[:tags] << tag_count_error(resource)            if resource.tags.size > MAX_TAGS
  end
  
  private
  
  def category_count_error(resource)
    "A #{resource.type} cannot have more than #{MAX_CATEGORIES} #{resource.class.category_type.pluralize}."  
  end
  
  def tag_count_error(resource)
    "A #{resource.type} cannot have more than #{MAX_TAGS} tags."        
  end
end