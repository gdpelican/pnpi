class SampleDecorator < ResourceDecorator
  delegate_all
  
  def file_url(size = :thumb)
    "/images/pdf.png"
  end
  
  def sample_url
    object.picture.url
  end

end
