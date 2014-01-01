module MenuHelper
  
  def menu_link(text, href)
    content_tag :li, link_to(text, href), class: 'link'
  end

end
