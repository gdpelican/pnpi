class ActiveRecord::Relation
  
  def sanitize(field)
    pluck(field.to_sym).uniq.map { |f| { name: f, value: f.parameterize.underscore } }
  end
  
end