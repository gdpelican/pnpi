class SampleValidator < ActiveModel::Validator
  def validate(sample)
    sample.errors[:base] << sample_blank_error if no_sample_present? sample
    sample.errors[:base] << sample_multi_error if multiple_samples_present? sample 
  end
  
  private
  
  def sample_blank_error
    'Must specify either a file to upload or a web link'
  end

  def sample_multi_error
    'Cannot specify both a file to upload and a web link'
  end
  
  def no_sample_present?(sample)
    sample.sample.blank? && sample.link.blank?
  end

  def multiple_samples_present?(sample)
    sample.picture_file_name.present? && sample.link.present?
  end 
  
end