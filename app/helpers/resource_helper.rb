module ResourceHelper
 
  def detail_item(icon, text = '', link = '')
    text = link_to text, link, target: :_blank if link.present? and text.present?
    content_tag :li, font_icon(icon) + ' ' + text, class: 'detail' if text.present?
  end

  def resource_action(action, resource, admin)
    data = case action
    when :back then
      { icon: 'user',
        text: 'Back to my profile',
        show: current_user.present? && resource.owners.include?(current_user.person),
        href: edit_person_path(current_user.person) }
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
  
  def submit_path(resource)
    resource_path(resource, resource.id.nil? ? :index : :show)
  end
  
  def resource_path(resource, action)
    action = :new if resource.id.nil? && action == :edit
    
    type = resource.type.downcase
    case action
    when :index then send "#{type.pluralize}_path"
    when :new then send "new_#{type}_path", resource
    when :show then send "#{type}_path", resource
    when :edit then send "edit_#{type}_path", resource end
  end
  
  def resource_by_owner_path(owner, resource)
    if resource.id.present? then resource_path(resource, :edit)
    else                         new_resource_by_owner_path(owner, resource.type.downcase.pluralize) end
  end

  private
  
  def form_action_confirm_text(action, type, message)
    "Are you sure you want to #{action} this #{type}? #{message}" if message.present?
  end
  
end
