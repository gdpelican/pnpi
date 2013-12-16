module ApplicationHelper
  
  def hash_field(field)
    Proc.new { |f| f[field] }
  end

end
