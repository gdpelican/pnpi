class SearchService
  
  @@model = Resource
  
  def self.search(params, paging = true)
    params[:term] = '' if params[:term] == '*'
    
    results = case params[:search].to_sym
    when :filter then filter_search resource: params[:resource], category: params[:category]
    when :text   then text_search   term: params[:term]
    when :all    then get_all
    else              get_none 
    end
    
    results = results.active.uniq.order(:name)
    results = tag_search results, tags: params[:tags]                                if params[:tags]
    results = paging results,     page: params[:page], page_size: params[:page_size] if paging
    results
  end
  
  def self.count(params)
    search(params, false).count
  end
  
  private
  
  def self.filter_search(resource: '', category: '')
    @@model.joins('LEFT OUTER JOIN "categories_resources" on "categories_resources"."resource_id" = "resources"."id"')
           .joins('LEFT OUTER JOIN "categories" on "categories_resources"."category_id" = "categories"."id"')
           .references(:categories) 
           .where(type: resource.humanize)
           .where('? or categories.name = ?', (category.blank?) ? "TRUE" : "FALSE", (category || '').humanize)
  end
  
  def self.text_search(term: '')
    @@model.where('name ilike ? OR description ilike ?', "%#{term}%", "%#{term}%")
  end
  
  def self.tag_search(results, tags: '')
    results.joins('LEFT OUTER JOIN "resources_tags" on "resources_tags"."resource_id" = "resources"."id"')
           .joins('LEFT OUTER JOIN "tags" on "resources_tags"."tag_id" = "tags"."id"')
           .where('? or tags.id in (?)', (tags.empty?) ? "TRUE" : "FALSE", tags)    
  end
  
  def self.get_all
    @@model.all
  end
  
  def self.get_none
    @@model.none
  end
    
  def self.paging(results, page: 1, page_size: 10)
    results.limit([page_size, 1].max)
           .offset([page_size, 1].max * ([page.to_i, 1].max - 1))
  end
  
  
end