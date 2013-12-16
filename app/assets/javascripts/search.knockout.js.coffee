class @KnockoutSearch
  constructor: (json) ->
    @resource =    ko.observable(json.resource or '')
    @category =    ko.observable(json.category or '')
    @page =        ko.observable(json.page)
    
    @initialView = ko.observable(true)
    @searchView =  ko.observable("filter")
  
    @resources =   ko.observableArray(json.resources or [])
    @categories =  ko.observableArray(json.categories or [])
    @tags =        ko.observableArray(json.tags or [])
    @results =     ko.observableArray([])
    
    @term =        ko.observable('')
    
    @cache = {}
    
    @tag_list =    ko.observableArray(json.tag_list or [])
    @errors =      ko.observableArray([])

    @leadText =       ko.computed => 
      switch @searchView()
        when 'filter' then 'I\'m looking for a '
        when 'text'   then 'I\'m looking for '
        else               ''
    @filterView =     ko.computed => @searchView() == 'filter'
    @textView =       ko.computed => @searchView() == 'text'
        
    @showPredicate =  ko.computed => @resource().length > 0
    @showSubmit =     ko.computed => @resource().length > 0 and @category() and @category().length > 0
    @predicate =      ko.computed =>
      switch @resource()
        when 'person' then ' who is a '
        when 'place'  then ' to have a '
        when 'thing'  then ' that I can '
        else               ''
    
    @postUrl =        ko.computed =>
      switch @searchView()
        when 'filter' then '/search/' + @resource() + '/' + (if @category() then @category() + '/' + (if @page() then @page() else '') else '')
        when 'text'   then '/search/text/' + @term() + '/' + (if @page() then @page else '')
    
    @swapView = ->
      switch @searchView()
        when 'filter' then @searchView('text')
        when 'text'   then @searchView('filter')
    
    @fetchCategories = (data, event) ->
      @resource(event.currentTarget.value)
      if @resource().length = 0
        @category ''
      else
        cacheKey = 'category_' + @resource()
        if @cache[cacheKey]
          @update(@cache[cacheKey]) 
        else
          @handle(false, cacheKey)
    
    @fetchTags = (data, event) ->
      @category(event.currentTarget.value)
      @tags([])
      cacheKey = 'tags_' + @resource() + '_' + @category()
      if @cache[cacheKey]
        @update(@cache[cacheKey])
      else
        @handle(false, cacheKey)
        
    @search = ->
      @handle(true)
    
    @handle = (search, cacheKey) ->
      $.ajax 
        type: 'POST'
        url: @postUrl()
        data:
          tags: @tags()
          do_search: search
        success: (json) => @update(json, cacheKey, search)
        failure: (json) => @failure(json)
        
    @update = (json, cacheKey, killInitialState) ->
      @resources json.resources
      @categories json.categories
      @tag_list json.tag_list
      if json.tags? then @tags json.tags
      if json.results? then @setResults json.results
      if cacheKey then @cache[cacheKey] = json
      if killInitialState then @initialView(false)
   
    @failure = (json) ->
      @errors(json.errors)
    
    @setResults = (results) ->
      @results(new KnockoutResource(result) for result in results)