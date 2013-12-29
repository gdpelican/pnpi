class PossessionDecorator < Draper::Decorator
  delegate_all
  
  def resource?
    defined? object.type
  end
  
  def image_abbrev?
    id.present? and resource?
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
 
end
