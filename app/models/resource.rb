class Resource < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :owners, 
    class_name:              'Person',
    join_table:              :owners_possessions,
    association_foreign_key: :owner_id,
    foreign_key:             :possession_id
  
  validates :name, length: { minimum: 3 }
  validates :preview, length: { maximum: 140 }
  validates_associated :tags
  validates_associated :categories
  validates :type, inclusion: { in: ['Person', 'Place', 'Thing', 'Sample'] }
  validate :validate_tag_count
  validate :validate_category_count
  
  serialize :details, Hash
  after_initialize :define_details_methods
  
  scope :named, ->(name) { where(name: name) }
  
  scope :include_children, -> { includes([:tags, :categories]) }
  
  scope :filter_search, ->(resource, category) {  
    joins('LEFT OUTER JOIN "categories_resources" on "categories_resources"."resource_id" = "resources"."id"')
   .joins('LEFT OUTER JOIN "categories" on "categories_resources"."category_id" = "categories"."id"')
   .where(type: resource.humanize)
   .where('? or categories.name = ?', (category.blank?) ? "TRUE" : "FALSE", category.humanize).references(:categories) }  
      
  scope :text_search, ->(term = '%') { 
    where('name ilike ? OR description ilike ?', "%#{term}%", "%#{term}%") }
  
  scope :tag_search, ->(tags) { 
    joins('LEFT OUTER JOIN "resources_tags" on "resources_tags"."resource_id" = "resources"."id"')
   .joins('LEFT OUTER JOIN "tags" on "resources_tags"."tag_id" = "tags"."id"')
   .where('? or tags.id in (?)', (tags.empty?) ? "TRUE" : "FALSE", tags)
  }
  
  scope :paging, ->(options = {}) {
    limit( [options[:page_size], 1].max)
   .offset([options[:page_size], 1].max * ([options[:page].to_i, 1].max - 1)) }
  
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
     :path => "/:style/:id/:filename",
     :bucket => 'PNPI-Resource'  
  
  def assign_attributes(attr, options={})
    self.class.details.each do |detail|
      self.details[detail] = attr.delete detail
    end
    super(attr)
  end
  
  def validate_category_count
    errors.add(:categories, "A #{type} cannot have more than #{self.class.max_categories} #{self.class.category_type.pluralize}.") if self.categories.size > self.class.max_categories
  end
  
  def validate_tag_count
    errors.add(:tags, "A #{type} cannot have more than #{self.class.max_tags} tags.") if self.tags.size > self.class.max_tags    
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
  
  def self.max_categories
    3
  end
  
  def self.max_tags
    7
  end
  
  def self.search(options = {})
    Resource.retrieve(options).paging(options)
  end
  
  def self.count(options = { search: :all })
    Resource.retrieve(options).count
  end
  
  def self.retrieve(options = {})
    options[:term] = '' if options[:term] == '*'
    results = case options[:search].to_sym
              when :filter then filter_search options[:resource] || '', options[:category] || ''
              when :text   then text_search options[:term]
              when :all    then all
              else              none end
    results = results.tag_search options[:tags] if options[:tags]
    results.active.uniq.order(:name)
  end

  def self.types
    Resource.except(:sample).sanitize(:type)
  end
  
  def self.mass_fields
    [:id, :name, :preview, :description, :picture, :active, :_destroy, tag_ids: [], category_ids: []] | self.details
  end
  
  def self.details
    []
  end
  
end