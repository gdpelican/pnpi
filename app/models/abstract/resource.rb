class Resource < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :owners, 
    class_name:              'Person',
    join_table:              :owners_possessions,
    association_foreign_key: :owner_id,
    foreign_key:             :possession_id
                                   
  validates :name, length: { minimum: 3 }
  validates_associated :tags
  validates_associated :categories
  validates :type, inclusion: { in: ['Person', 'Place', 'Thing'] }
  
  serialize :details, Hash
  after_initialize :define_details_methods
  
  scope :named, ->(name) { where(name: name) }
  
  scope :filter_search, ->(resource = '', category = '') {  
    joins(:categories)
   .where(type: resource.humanize)
   .where('categories.name = ?', category.humanize).references(:categories) }  
      
  scope :text_search, ->(term = '%') { 
    where('name ilike ? OR description ilike ?', "%#{term}%", "%#{term}%") }
  
  scope :tag_search, ->(tags = nil) { 
    joins(:tags)
   .where('? or tags.id in (?)', (tags.nil? || tags.empty?) ? "TRUE" : "FALSE", tags)
   .references(:tags)
  }
  
  scope :paging, ->(page, page_size) {
    limit(page_size)
   .offset(page_size * (page.to_i - 1)) }
  
  has_attached_file :picture,
     :styles => { :original => ["1024x1024", :jpeg], 
                  :thumb => ["250x250", :jpeg], 
                  :tiny => ["100x100#", :jpeg] },
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
    super(options.merge!({ only: [:id, :name, :description, :preview], include: :tags }))
                 .merge!({ show_url: url(:show), picture_url: picture.url(:tiny) })
  end
  
  def url(path = :index)
    url = "/#{type.downcase.pluralize}/"
    case path
      when :show
        url << "#{self.id}"
      when :edit
        url << "#{self.id}/edit"
      when :new
        url << "new"
      when :index
        url
    end
  end
  
  def self.search(options = {})
    Resource.retrieve(options).paging(options[:page], options[:page_size])
  end
  
  def self.count(options = {})
    Resource.retrieve(options).count
  end
  
  def self.retrieve(options = {})
    results = case options[:search]
    when :filter then filter_search options[:resource], options[:category]
    when :text   then text_search options[:term]
    when :all    then Resource.all
    else              Resource.none end
    results.tag_search(options[:tags]).uniq
  end

  def self.types
    Resource.all.sanitize(:type)
  end
  
  def self.mass_fields
    [:id, :preview, :description, :picture, tag_ids: [], category_ids: []] | self.details
  end
  
end