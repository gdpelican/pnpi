module FormHelper
  
  def form_title
    content_tag :h1, action_name == 'show' ? @resource.name : action_name.humanize + ' ' + @type
  end

  def string_input(form, symbol, type, options = {})
    options[:tooltip] ||= INFO[form.object.type.downcase.to_sym][symbol]
    render partial: 'resources/input', 
           locals: { f: form, 
                     symbol: symbol, 
                     type: type, 
                     options: options }
  end
    
  def tag_collection(resource)
    (action_name.to_sym == :show) ? @tags.slice(*resource.tags.map { |tag| tag.tag_type.name })
                                  : @tags || []
  end
  
  def select_input(form, symbol, collection, options = {})
    form.input symbol, wrapper_html: { class: "block #{options[:field_size] || 'select-full'} #{options[:css]}" }, 
                       collection: options_for_select(collection, options[:value]),
                       label: input_label(symbol, options[:prompt], options[:icon]),
                       as: :select
  end

  def input_label(symbol, prompt = nil, icon = nil)
    "#{font_icon(icon) if icon} #{prompt || symbol.to_s.humanize}".html_safe
  end

  def nested_image(nested)
    nested.id.nil? ? '+' : image_tag(nested.file_url(:tiny))
  end
  
  def selected?(model, field, assoc)
    model.send(field).map(&:id).include? assoc.id
  end
  
end