module MenuHelper
  
  def menu_link(text, href='', &block)
    content_tag :li, '', class: 'link menu-link' do
      concat content_tag :label, if href then link_to(text, href) else text end
      concat content_tag :ul, &block
    end
  end
  
  def submenu_link(text, href)
    content_tag :li, link_to(text,href), class: 'link submenu-link'
  end

end
