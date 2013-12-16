class Sample < ActiveRecord::Base
  belongs_to :skill, foreign_key: 'categories_resource_id'
  
  validates :skill, presence: true
end
