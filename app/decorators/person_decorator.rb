class PersonDecorator < ResourceDecorator
  delegate_all
  
  def nested
    [:places, :things, :samples]
  end
  
  def places
    append_n_decorate :places
  end
  
  def things
    append_n_decorate :things
  end
  
  def samples
    append_n_decorate :samples
  end
  
  private
  
  def append(field)
    object.send(field).to_a.push field.to_s.singularize.humanize.constantize.new
  end
  
  def decorate(collection)
    PossessionDecorator.decorate_collection collection
  end
  
  def append_n_decorate(field)
    decorate append field
  end
 
end