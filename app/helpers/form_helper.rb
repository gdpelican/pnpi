module FormHelper
  
  def check_box_collection(form, symbol, collection, name_field = :name, value_field = :id)
    form.input symbol, as: :check_boxes, collection: collection, member_label: hash_field(name_field), member_value: hash_field(value_field)
  end

end
