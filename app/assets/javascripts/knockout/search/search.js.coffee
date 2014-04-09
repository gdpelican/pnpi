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

    @handleEnter = (data, event) =>
      if event.charCode == 13
        @search().term event.currentTarget.value
        @handleFetchEvent(data, event)
      true
    
    @handleTagToggle = (data, event) =>
      ko.utils.addOrRemoveItem(@search().tags, event.target.value, event.target.checked)
      @search().page 1
      @handleFetchEvent(data, event)
    
    @handleFetchEvent = (data, event) =>
      if @canHandle()
        @canHandle false
        @fetchResults data, event
    
    @fetchCategories = (data, event) =>
      @search().resource(event.currentTarget.value)
      if @search().resource().length == 0
        @search().category ''
      else
        @search().fetch @update, @failure, 'categories'

    @fetchResults = (data, event) =>
      event.stopPropagation()
      $(event.currentTarget).data('changed', false)
      @search().fetch @update, @failure
      
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
    
    @next = => @search().nextPage(@update, @failure)
    @prev = => @search().prevPage(@update, @failure)
