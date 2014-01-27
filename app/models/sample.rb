class Sample < Resource
  
  validates :name, length: { minimum: 3 }
  
  alias :sample :picture

  validates :sample, presence: true
  
  def sample_file_extension
    File.extname(picture_file_name || 'missing.pdf').gsub('.', '')
  end
  
  def asset?
    !(asset_content_type =~ /^image.*/).nil?
  end
  
  def self.category_type
    'Job'
  end
  
  def self.details
    []
  end
     
  def self.mass_fields
    super | [:sample]
  end
  
end
