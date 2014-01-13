class PossessionDecorator < Draper::Decorator
  delegate_all
  
  def resource?
    defined? object.type
  end
  
  def image_abbrev?
    id.present? and resource?
  end
  
  def name
    object.send(:name)
  end
  
  def avatar
    case type.to_sym
    when :sample then "/images/#{object.sample_file_extension}.png"
    when :tag then ''
    else object.picture.url(:tiny) end
  end
  
  def abbrev
    if id.nil?
      '+'
    elsif resource?
      object.picture.url(:tiny)
    else
      object.name[0]
    end
  end
  
  def type
    object.class.to_s.downcase
  end
 
  def show_path
    case type.to_sym
    when :sample then object.sample.url
    else              "/#{type.downcase.pluralize}/#{object.id}"
    end if object.id
  end
  
  def show_target
    '_blank' if type.to_sym == :sample  
  end
 
end
