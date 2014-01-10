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
 
  def detail_item(icon, text = '', link = '')
    text = link_to text, link, target: :_blank if link.present? and text.present?
    content_tag :li, font_icon(icon) + ' ' + text, class: 'detail' if text.present?
  end

  def resource_action(action, resource, admin)
    data = case action
    when :submit then
      submit_action(resource, admin).merge({ show: true })
    when :deactivate
      { icon: 'thumbs-o-down', 
        confirm: " It will not be editable or visible in searches.",
        show: admin && resource.active }
    when :delete
      { icon: 'trash-o', 
        confirm: " This action cannot be undone.",
        show: admin && resource.inactive? && !resource.unsaved?,
        href: resource,
        method: action }
    end
    
    link_to font_icon(data[:icon]) + (data[:text] || " #{action.to_s.humanize} #{resource.type}"), 
            data[:href] || 'javascript:;', 
            class: "#{action}-link action-link",
            method: data[:method],
            data: { 
              confirm: form_action_confirm_text(action, resource.type, data[:confirm]) } if data[:show]
  end
  
  def submit_action(resource, admin)
    if resource.unsaved? && resource.person? && !admin?
      { icon: 'check-square-o', text: ' Submit for approval' }
    elsif resource.unsaved?
      { icon: 'check-square-o', text: " Create #{resource.type.downcase}" }
    elsif resource.inactive? && admin
      { icon: 'thumbs-o-up', text: " Approve #{resource.type}" }
    else                                   
      { icon: 'save', text: ' Save Changes' } 
    end
  end

  private
  
  def form_action_confirm_text(action, type, message)
    "Are you sure you want to #{action} this #{type}? #{message}" if message.present?
  end
  
end
