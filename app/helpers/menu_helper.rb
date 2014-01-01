module MenuHelper
  
  def menu_link(text, href)
    content_tag :li, link_to(text, href), class: 'link'
  end
  
  def submit_text(type, update)
    if update then font_icon('save') + ' Save Changes'
    else           font_icon('asterisk') + ' Create ' + type.humanize end
  end

end
