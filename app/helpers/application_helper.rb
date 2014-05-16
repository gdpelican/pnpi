module ApplicationHelper
  
  def hash_field(field)
    Proc.new { |f| f[field] }
  end
  
  def search?
    controller_name == 'search'
  end
  
  def login?
    controller_name == 'sessions'
  end
  
  def admin?
    current_user.present? && current_user.admin?
  end
  
  def create?
    @resource.present? && @resource.person? && action_name.to_sym == :new
  end
  
  def user_avatar
    image_tag current_user.person.picture.url(:tiny) if current_user && current_user.person.picture.present?
  end
  
  def flash
    if    alert then alert.html_safe
    elsif notice then notice.html_safe end
  end

  def flash_type
    if    alert then 'alert'
    elsif notice then 'notice' end
  end
  
  def font_icon(icon, css='', size='lg')
    "<i class=\"fa fa-#{icon} #{css} #{'fa-' + size}\"></i>".html_safe
  end
  
  def info(type, field)
    INFO[underscore type][underscore field] || INFO[underscore field] if field
  end

  private
  
  def underscore(param)
    param.to_s.parameterize('_').to_sym
  end

end
