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
  
  def font_icon(icon, size='lg')
    "<i class=\"fa fa-#{icon} #{'fa-' + size}\"></i>".html_safe
  end
  
  def info(type, field)
    INFO[underscore type][underscore field] || INFO[underscore field] if field
  end

  private
  
  def underscore(param)
    param.to_s.parameterize('_').to_sym
  end

end
