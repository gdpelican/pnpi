module ApplicationHelper
  
  def hash_field(field)
    Proc.new { |f| f[field] }
  end
  
  def devise_controller?
    [:sessions, :registrations].include? controller_name.to_sym
  end

end
