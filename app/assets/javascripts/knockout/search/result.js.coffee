class @KnockoutSearchResult
  constructor: (json = {},loggedIn = false, methods = null) ->
    
    @o_type =      ko.observable(if json.type is 'text' and json.term in ['*', '', 'null'] then 'all' else json.type)
    @o_resource =  ko.observable(json.resource or '')
    @o_category =  ko.observable(json.category or '')
    @o_term =      ko.observable(json.term or '')
   
    @methods =     methods
    @type =        ko.observable(if json.type in ['new', 'all'] then 'filter' else json.type)
    @resource =    ko.observable(@o_resource())
    @category =    ko.observable(@o_category())
    @term =        ko.observable(@o_term())
    @tags =        ko.observableArray([])
    
    @page =        ko.observable(json.page or 1)
    @maxPage =     ko.observable(json.max_page or 1)
    @showTags =    ko.observable(false)
    
    @results =     ko.observableArray(new KnockoutResource(result, loggedIn) for result in (json.results || []))

    @summaryResource = ko.computed =>
      switch @o_resource()
        when 'person' then 'people who are '
        when 'place'  then 'places for a '
        when 'thing'  then 'things available for '
        else ''
    @summaryCategory = ko.computed =>
      switch @o_resource()
        when 'person' then @o_category() + 's'
        else               @o_category()
    
    @hasResults =  ko.computed => @results().length > 0
    @json = (type = null) =>
      type:     type || @type()
      resource: @resource()
      category: @category()
      term:     @term()
      page:     @page()
      max_page: @maxPage()
      tags:     @tags()
      
    @update = (json) =>
      @o_type     json.type
      @o_resource json.resource
      @o_category json.category
      @o_term     json.term
      @tags       json.tags
      @results    (json.results.map (result) -> new KnockoutResource result, loggedIn) || []
      
      @type     if json.type in ['new'] then 'filter' else json.type
      @resource json.resource
      @category json.category
      @term     json.term
      @page     json.page
      @maxPage  json.max_page
            
    @prevPage = (success, failure) ->
      @page(@page() - 1)
      @fetch success, failure, @o_type()
      
    @nextPage = (success, failure) ->
      @page(@page() + 1)
      @fetch success, failure, @o_type()

    @fetch = (success, failure, type) ->  
      @methods.search @json(type), success, failure
    
    @showPredicate = ko.computed => !!@resource()
    @predicate =     ko.computed =>
      switch @resource()
        when 'person' then ' who is a '
        when 'place'  then ' to have a '
        when 'thing'  then ' available to '
        else ''
        
    @searchSummary = ko.computed =>
      @o_type('all') if @o_type() == 'text' and @term() in ['', 'null', '*']
      typeText = switch @o_type()
        when 'filter' then "Displaying #{@summaryResource()} #{@summaryCategory()}"
        when 'text'   then "Displaying results with text \'#{@o_term()}\'"
        when 'all'    then "Displaying all records"
        else               ""
                
      tagsText = if @tags().length > 0 then \
      " with tags " + ("'#{@methods.tagLookup(id)}'" for id in @tags()) else ""
        
      pageText = \
      ", page #{@page()} of #{@maxPage()}"
      "#{typeText}#{tagsText}#{pageText}"
      
    @canSearch =     ko.computed =>
      if (@type() == 'text') or \
         (@type() == 'filter' and \
         !!@resource() and \
         !!@category()) then true else false
    
    @toggleTagPanel = =>
      @showTags !@showTags()
    
    @toggleTag = (tag) =>
      if @tags.indexOf(tag) < 0 then @tags().push(tag)
      else                           @tags.remove(tag)
      @page 1
    
    @typeSwap = =>
      switch @type()
        when 'filter' then @type 'text'
        when 'text'   then @type 'filter'
