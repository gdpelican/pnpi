class SampleDecorator < ResourceDecorator
  delegate_all
  
  def file_url(size = :thumb)
    "/images/#{object.sample_file_extension.gsub('.','')}.png"
  end
  
  def sample_url
    object.picture.url
  end

end
