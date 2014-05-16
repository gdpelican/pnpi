class ResourceValidator < ActiveModel::Validator
  MAX_CATEGORIES = 3
  MAX_TAGS = 7
  MIN_NAME_LENGTH = 3
  MAX_PREVIEW_LENGTH = 140
  
  def validate(resource)
    resource.errors[:name] << name_length_error(resource)          if resource.name.blank? || resource.name.length < MIN_NAME_LENGTH
    resource.errors[:preview] << preview_length_error(resource)    if resource.preview && resource.preview.length > MAX_PREVIEW_LENGTH
    resource.errors[:categories] << category_count_error(resource) if resource.categories.size > MAX_CATEGORIES
    resource.errors[:tags] << tag_count_error(resource)            if resource.tags.size > MAX_TAGS
  end
  
  private
  
  def name_length_error(resource)
    "A #{resource.type} cannot have a name less than #{MIN_NAME_LENGTH} characters"
  end

  def preview_length_error(resource)
    "A #{resource.type} cannot have an intro snippet longer than #{MAX_PREVIEW_LENGTH} characters"
  end

  def category_count_error(resource)
    "A #{resource.type} cannot have more than #{MAX_CATEGORIES} #{resource.class.category_type.pluralize}."  
  end
  
  def tag_count_error(resource)
    "A #{resource.type} cannot have more than #{MAX_TAGS} tags."        
  end
end