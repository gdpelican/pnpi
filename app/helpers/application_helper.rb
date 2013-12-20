module ApplicationHelper
  
  def hash_field(field)
    Proc.new { |f| f[field] }
  end
  
  def admin?
    current_user.present? && current_user.admin?
  end
  
  def user_avatar
    image_tag current_user.person.picture.url(:tiny) if current_user && current_user.person.picture.present?
  end
  
  def font_icon(icon, size='lg')
    "<i class=\"fa fa-#{icon} #{'fa-' + size}\"></i>".html_safe
  end

end
