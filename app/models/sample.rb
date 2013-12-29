class Sample < ActiveRecord::Base
  
  validates :name, length: { minimum: 3 }
  
  belongs_to :person
  belongs_to :job
  
  has_attached_file :sample,
     :storage => :s3,
     :s3_credentials => "#{Rails.root}/config/s3.yml",
     :path => "/:style/:id/:filename",
     :bucket => 'PNPI-Sample'
     
  def self.mass_fields
    [:id, :name, :sample, :_destroy]
  end
end
