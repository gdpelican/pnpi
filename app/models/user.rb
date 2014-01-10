class User < ActiveRecord::Base

  belongs_to :person
      
  devise :database_authenticatable, :registerable, :validatable, :rememberable, :recoverable
  
  validates :password, length: { in: 6..15 }
  
  attr_accessor :email, :password
  
  def email
    self.person.email if self.person
  end
  
  def email_changed?
    false
  end
  
  def self.find_by_person(person)
    User.where(person_id: person.id).first
  end
  
end
