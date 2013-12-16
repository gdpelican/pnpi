class User < ActiveRecord::Base

  belongs_to :resource
  
  attr_accessor :email
  before_save :set_email
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  def email_changed?
    self.email != self.resource.email
  end
    
  def set_email
    resource.update_column :email, self.email
  end
  
end
