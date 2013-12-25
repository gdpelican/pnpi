class @KnockoutSearchResult
  constructor: (json = {}, page = 1, max_page = 1) ->
    @methods =     new KnockoutSearchMethods()
    @type =        ko.observable(json.type or 'filter')
    @resource =    ko.observable(json.resource or '')
    @category =    ko.observable(json.category or '')
    @term =        ko.observable(json.term)
    @page =        ko.observable(page)
    @maxPage =     ko.observable(max_page)
    @loading =     ko.observable(false)
    
    @tags =        ko.observableArray(json.tags or [])
    @results =     ko.observableArray(json.results or [])
    
    @hasResults =  ko.computed => !@loading() && @results().length > 0
    @json =        ko.computed =>
      type:     @type()
      resource: @resource()
      category: @category()
      term:     @term()
      page:     @page()
      tags:     @tags()
      
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