class Resource < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :owners, 
    class_name:              'Person',
    join_table:              :owners_possessions,
    association_foreign_key: :owner_id,
    foreign_key:             :possession_id
  
  validates_associated :tags
  validates_associated :categories
  validates :type, inclusion: { in: ['Person', 'Place', 'Thing', 'Sample'] }
  validates_with ResourceValidator
  
  serialize :details, Hash
  after_initialize :define_details_methods
  
  scope :named, ->(name) { where(name: name) }
  scope :include_children, -> { includes([:tags, :categories]) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :recent, -> { active.order('created_at DESC').limit(5) }
  scope :except, ->(type) { where('type <> ?', type.to_s.humanize) }
  
  has_attached_file :picture,
     :styles => { :thumb => ["250x250#", :jpeg], 
                  :original => ["1024x1024", :jpeg], 
                  :tiny => ["100x100#", :jpeg] },
     :whiny => false,
     :storage => :s3,
     :default_url => :default_url,
     :s3_credentials => "#{Rails.root}/config/s3.yml",
     :path => ":id/:style/:filename.:extension",
     :bucket => "pnpi_#{Rails.env}"
  
  def assign_attributes(attr, options={})
    self.class.details.each do |detail|
      self.details[detail] = attr.delete detail unless attr[detail].nil?
    end
    super(attr)
  end
  
  def define_details_methods
    self.class.details.each do |detail|
      define_singleton_method "#{detail}=", ->(value) { self.details[detail] = value }
      define_singleton_method "#{detail}", -> { self.details[detail] }
    end
  end
    
  def default_url
    "/images/missing_#{self.type.downcase}.png"
  end
    
  def as_json(options={})
    super(options.merge!({ only: [:id, :type, :name, :description, :preview], include: :tags }))
                 .merge!({ show_url: "/#{type.to_s.downcase.pluralize}/#{id}", picture_url: picture.url(:tiny) })
  end

  def self.types
    Resource.except(:sample).sanitize(:type)
  end
  
  def self.mass_fields
    [:id, :name, :preview, :description, :picture, :active, :_destroy, owner_ids: [], tag_ids: [], category_ids: []] | self.details
  end
  
  def self.details
    []
  end
  
end