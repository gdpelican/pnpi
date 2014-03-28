class @KnockoutSearchResult
  constructor: (json = {}, loggedIn = false) ->
    json.type = 'filter' if json.type in ['new', 'all']
    
    @methods =     new KnockoutSearchMethods()
    @type =        ko.observable(json.type || 'filter')
    @resource =    ko.observable(json.resource or '')
    @category =    ko.observable(json.category or '')
    @term =        ko.observable(json.term or '')
    @page =        ko.observable(json.page or 1)
    @maxPage =     ko.observable(json.max_page or 1)
    @loading =     ko.observable(false)
    
    @tags =        ko.observableArray(json.tags or [])
    @results =     ko.observableArray(new KnockoutResource(result, loggedIn) for result in (json.results || []))

    @hasResults =  ko.computed => !@loading() && @results().length > 0
    @json =        ko.computed =>
      type:     @type()
      resource: @resource()
      category: @category()
      term:     @term()
      page:     @page()
      max_page: @maxPage()
      tags:     @tags()
      
    @update = (json) =>
      @type     json.type
      @resource json.resource
      @category json.category
      @term     json.term
      @page     json.page
      @maxPage  json.max_page
      @tags     json.tags or []
      
      @results (json.results.map (result) -> new KnockoutResource result, loggedIn) || []
            
    @prevPage = (success, failure) ->
      @page(@page() - 1)
      @fetch @type(), success, failure
      
    @nextPage = (success, failure) ->
      @page(@page() + 1)
      @fetch @type(), success, failure

    @fetch = (type, success, failure) ->
      @loading type in ['filter', 'text', 'all']
      s = (data) =>
        @loading false
        success(data)
      f = (data) =>
        @loading false
        failure(data)
          
      @methods.search type, @json(), s, f
    
    @showPredicate = ko.computed => !!@resource()
    @predicate =     ko.computed =>
      switch @resource()
        when 'person' then ' who is a '
        when 'place'  then ' to have a '
        when 'thing'  then ' that I can '
        else ''  

    @canSearch = ko.computed =>
      if (@type() == 'text') or \
         (@type() == 'filter' and \
         !!@resource() and \
         !!@category()) then true else false
         
    @typeSwap = =>
      switch @type()
        when 'filter' then @type 'text'
        when 'text'   then @type 'filter'
      
