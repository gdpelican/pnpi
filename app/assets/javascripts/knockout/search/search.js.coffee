class @KnockoutSearch
  constructor: (json = {}, user = false, methods = new KnockoutSearchMethods()) ->
    
    @methods =     methods
    
    @initialView = ko.observable(!json.results)
  
    @resources =   ko.observableArray(json.resources or [])
    @categories =  ko.observableArray(json.categories or [])
    @tagList =     ko.observableArray([])
    @errors =      ko.observableArray([])
    @canHandle =   ko.observable(true)

    @search =      ko.observable(new KnockoutSearchResult(json, user, methods))

    @loggedIn =    user

    @leadText =       ko.computed =>
      switch @search().type()
        when 'filter' then 'I\'m looking for a '
        when 'text'   then 'I\'m looking for '
        else               ''

    @enterFetchEvent = (data, event) =>
      if event.charCode == 13
        @search().term event.currentTarget.value
        @searchFetchEvent data, event
      true
    
    @searchFetchEvent = (data, event) =>
      @search().term '*' unless @search().term().length > 0
      @search().tags []
      @handleFetchEvent data, event
    
    @tagFetchEvent = (data, event) =>
      ko.utils.addOrRemoveItem(@search().tags, event.target.value, event.target.checked)
      @search().page 1
      @handleFetchEvent(data, event)
    
    @nextFetchEvent = (data, event) => 
      @search().page @search().page() + 1
      @handleFetchEvent data, event
    
    @prevFetchEvent = (data, event) =>
      @search().page @search().page() - 1
      @handleFetchEvent data, event
    
    @handleFetchEvent = (data, event) =>
      if @canHandle()
        @canHandle false
        @fetchResults data, event
    
    @fetchCategories = (data, event) =>
      @search().resource(event.currentTarget.value)
      if @search().resource().length == 0
        @search().category ''
      else
        @fetchResults data, event, 'categories'

    @fetchResults = (data, event, type) =>
      event.stopPropagation()
      @search().fetch @update, @failure, type
      
    @update = (json) =>
      @canHandle true
      switch json.type
        when 'categories'            then @categories(json.categories)
        when 'filter', 'text', 'all'
          @search().update(json)
          @populateTags(json.tag_list)
          @initialView(false)

    @populateTags = (tags) ->
      @tagList([])
      @methods.createTagLookup tags
      for type in Object.keys(tags)
        @tagList.push { name: type, \
                        tags: new KnockoutTag tag for tag in tags[type] }
        
    @populateTags(json.tag_list) if json.tag_list

    @failure = (json) =>
      @canHandle true
      @errors json.errors
