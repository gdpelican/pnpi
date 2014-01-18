class @KnockoutSearchMethods
  constructor: ->
    @cache = {}

    @search = (method, json, success, failure) ->
      cacheKey = @getCacheKey(method, json)
      data =
        tags: json.tags
      
      @cacheFetch data, cacheKey, success, failure
    
    @getCacheKey = (method, json) ->
      switch(method)
        when 'resources'
          "#{method}"
        when 'categories'
          "#{method}/#{json.resource}"
        when 'tags'
          "#{method}/#{json.resource}/#{json.category}"
        when 'filter'
          "#{method}/#{json.resource}/#{json.category}/#{json.page || 1}"
        when 'text'
          "#{method}/#{json.term}/#{json.page || 1}"
        when 'all'
          "#{method}/#{json.page || 1}"
        else
          ""
    
    @cacheFetch = (data, cacheKey, success, failure) =>
      if @cache[cacheKey] && (!data.tags? || data.tags.length == 0)
        success(@cache[cacheKey])
      else
        @handle data, cacheKey, success, failure
    
    @handle = (data, cacheKey, success, failure) ->
      $.ajax
        type: 'POST'
        url: '/search/' + cacheKey
        data: data
        success: (json) =>
          @cache[cacheKey] = json
          success(json)
        failure: (json) ->
          failure(json)