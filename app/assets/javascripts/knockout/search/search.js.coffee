class @KnockoutSearch
  constructor: (json) ->
    
    @currSearch =  ko.observable(new KnockoutSearchResult())
    @lastSearch =  ko.observable(new KnockoutSearchResult())
   
    @initialView = ko.observable(true)
    @tagView =     ko.observable(false)
  
    @resources =   ko.observableArray(json.resources or [])
    @categories =  ko.observableArray(json.categories or [])
    @tag_list =    ko.observableArray(json.tags or [])
    @errors =      ko.observableArray([])

    @leadText =       ko.computed =>
      switch @currSearch().type()
        when 'filter' then 'I\'m looking for a '
        when 'text'   then 'I\'m looking for '
        else               ''
            
    @tagClass =       ko.computed =>
      'tags-trigger' + if @tagView() then ' selected texture-background' \
                       else ''

    @showPredicate =  ko.computed => @currSearch().resource().length > 0
    @showSubmit =     ko.computed => @currSearch().resource().length > 0 and \
                                     @currSearch().category() and \
                                     @currSearch().category().length > 0
    @predicate =      ko.computed =>
      switch @currSearch().resource()
        when 'person' then ' who is a '
        when 'place'  then ' to have a '
        when 'thing'  then ' that I can '
        else               ''
    
    @swapView = =>
      switch @currSearch().type()
        when 'filter' then @currSearch().type('text')
        when 'text'   then @currSearch().type('filter')
      
    @swapTagView = (data, event) =>
      @tagView(!@tagView())
    
    @fetchCategories = (data, event) =>
      @currSearch().resource(event.currentTarget.value)
      if @currSearch().resource().length == 0
        @currSearch().category('')
        @tagView false
      else
        @currSearch().fetch 'categories', @update, @failure
    
    @fetchTags = (data, event) =>
      @currSearch().category(event.currentTarget.value)
      if @currSearch().category().length == 0
        @tagView false
      else
        @currSearch().tags([])
        @currSearch().fetch 'tags', @update, @failure
        
    @fetchResults = (data, event) =>
      @currSearch().fetch @currSearch().type(), @update, @failure
    
    @update = (json) =>
      switch(json.type)
        when 'resources'     then @resources(json.results)
        when 'categories'    then @categories(json.results)
        when 'tags'          then @tag_list(json.results)
        when 'filter','text' then @setResults(json)

    @failure = (json) =>
      @errors(json.errors)
    
    @setResults = (json) ->
      @initialView(false)
      @lastSearch(new KnockoutSearchResult(@currSearch().json(), \
                                           json.page, \
                                           json.max_page))
      @lastSearch().results(@wrapResults(json.results))
    
    @wrapResults = (results) ->
      new KnockoutResource(result) for result in results
    
    @next = => @lastSearch().nextPage(@update, @failure)
    @prev = => @lastSearch().prevPage(@update, @failure)
    