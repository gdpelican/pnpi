class @KnockoutSearch
  constructor: (json = {}, user = false) ->
    
    @initialView = ko.observable(!json.results)
    @tagView =     ko.observable(false)
  
    @resources =   ko.observableArray(json.resources or [])
    @categories =  ko.observableArray(json.categories or [])
    @tag_list =    ko.observableArray(json.tags or [])
    @errors =      ko.observableArray([])

    @search =      ko.observable(new KnockoutSearchResult(json, user))

    @loggedIn =    user

    @leadText =       ko.computed =>
      switch @search().type()
        when 'filter' then 'I\'m looking for a '
        when 'text'   then 'I\'m looking for '
        else               ''
            
    @tagClass =       ko.computed =>
      'tags-trigger' + if @tagView() then ' selected texture-background' \
                       else ''

    @swapTagView = (data, event) =>
      @tagView(!@tagView())    
    
    @handleEnter = (data, event) =>
      if event.charCode == 13
        @search().term event.currentTarget.value
        @fetchResults data, event
      true
    
    @fetchCategories = (data, event) =>
      @search().resource(event.currentTarget.value)
      if @search().resource().length == 0
        @search().category('')
        @tagView false
      else
        @search().fetch 'categories', @update, @failure
    
    @fetchTags = (data, event) =>
      @search().category event.currentTarget.value
      if @search().category().length == 0
        @tagView false
      else
        @search().tags([])
        @search().fetch 'tags', @update, @failure
       
    @fetchResults = (data, event) =>
      event.stopPropagation()
      results = if $(event.currentTarget).data('load') \
                then @elementSearch($(event.currentTarget)) \
                else @search()
      results.fetch results.type(), @update, @failure
    
    @elementSearch = (el) ->
      new KnockoutSearchResult
        type:     "#{el.data('type') || 'all'}"
        resource: "#{el.data('resource') || ''}"
        category: "#{el.data('category') || ''}"
        term:     "#{el.data('term') || '*'}"
        tags:     "#{el.data('tags')}".split ' '
      
    @update = (json) =>
      switch(json.type)
        when 'resources'            then @resources(json.results)
        when 'categories'           then @categories(json.results)
        when 'tags'                 then @tag_list(json.results)
        when 'filter','text', 'all' 
          @search().update(json)
          @initialView false

    @failure = (json) =>
      @errors json.errors
    
    @next = => @search().nextPage(@update, @failure)
    @prev = => @search().prevPage(@update, @failure)
