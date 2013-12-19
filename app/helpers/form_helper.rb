module FormHelper
  
  def registration_path(name)
    "/people/register"
  end
  
  def string_input(form, symbol, type, readonly = false, field_size = 'full', placeholder = (symbol.to_s.humanize + '. . .'))
    return if readonly && (form.object.send(symbol).nil? || [:first_name, :last_name, :name].include?(symbol))
    form.input symbol, wrapper_html: { class: "block #{field_size}#{' readonly' if readonly}" }, 
                       input_html: { placeholder: placeholder, readonly: readonly }, 
                       label: false,
                       as: type
  end
  
  def check_box_collection(form, symbol, collection, readonly = false, name_field = :name, value_field = :id)
    form.input symbol, collection: collection, 
                       disabled: (collection.map { |f| f.send(value_field) } if readonly),
                       member_label: hash_field(name_field), 
                       member_value: hash_field(value_field),
                       as: :check_boxes
  end

end
