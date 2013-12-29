module FormHelper
  
  def form_title
    content_tag :h1, action_name == 'show' ? @resource.name : action_name.humanize + ' ' + @type
  end
  
  def registration_path(name)
    "/people/register"
  end
  
  def string_input(form, symbol, type, field_size = 'full', options = {})
    form.input symbol, wrapper_html: { class: "block #{field_size} #{options[:css]}" }, 
                       input_html: { placeholder: options[:placeholder] || symbol.to_s.humanize + '. . .' }, 
                       label: options[:label] || false,
                       as: type
  end
  
  def select_input(form, symbol, options = {})
    form.input symbol, wrapper_html: { class: "block #{options[:field_size] || 'select-full'} #{options[:css]}" }, 
                       label: options[:label] || false,
                       collection: options[:collection],
                       include_blank: options[:placeholder],
                       value: form.object.send(symbol),
                       as: :select  
  end
  
  def categories_html(form, categories = {})
    form.object.thing? ? form.object.category_message
                       : check_box_collection(form, 
                                              :categories, 
                                              categories, 
                                              form.object.category_type)
  end
  
  def nested_menu_link(name)
    link_to(name.to_s.humanize,  'javascript:;', class: 'nested-menu-link selectable slide-to', data: { 'resource-type' => name, 'target' => 'nestedAnchor' })
  end
  
  def nested_menu_displays(form, name)
    render partial: '/resources/forms/nested_resources', locals: {f: form, field: name, name: name.to_s.singularize }
  end
  
  def nested_image(nested)
    if nested.image_abbrev? then image_tag(nested.abbrev) 
    else                         nested.abbrev end
  end
  
  def tag_collection(resource)
    (action_name.to_sym == :show) ? @tags.slice(*resource.tags.map { |tag| tag.tag_type.name })
                                  : @tags || []
  end
  
  def check_box_collection(form, symbol, collection, label = symbol, name_field = :name, value_field = :id)
    form.input symbol, collection: collection, 
                       member_label: hash_field(name_field), 
                       member_value: hash_field(value_field),
                       as: :check_boxes,
                       label: label
  end

end
