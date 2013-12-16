module ResourceHelper
  
  def resource_url(type, action = :index)
    url = "/#{type.downcase.pluralize}/"
    case path
      when :new
        url << "new"
      when :index
        url
    end
  end

end
