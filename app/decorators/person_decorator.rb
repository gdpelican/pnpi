class PersonDecorator < ResourceDecorator
  delegate_all
  
  def possessions
    [:places, :things, :samples]
  end
  
  def places(append = true)
    collection :places, append
  end
  
  def things(append = true)
    collection :things, append
  end
  
  def samples(append = true)
    collection :samples, append
  end
  
  def description_header
    'About Me'
  end
  
  def sample_header
    'My Work'
  end
  
  def details
    [{ text: email,   icon: 'envelope-o', link: "mailto:#{email}" }, 
     { text: website, icon: 'laptop',     link: website },
     { text: phone,   icon: 'phone' }]
  end
 
end