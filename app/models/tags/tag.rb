class Tag < ActiveRecord::Base
  has_and_belongs_to_many :resources
  belongs_to :tag_type
end
