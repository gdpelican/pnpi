class Sample < Resource
  
  alias :sample :picture

  validates_with SampleValidator
  
  def sample_file_extension
    self.link.present? ? '.html' : File.extname(picture_file_name || 'missing.pdf').gsub('.', '')
  end
  
  def asset?
    !(asset_content_type =~ /^image.*/).nil?
  end
  
  def self.category_type
    'Job'
  end
  
  def self.details
    [:link]
  end
     
  def self.mass_fields
    super | [:sample]
  end

end
