class @KnockoutSearchMethods
  constructor: ->
    @cache = {}

    @search = (method, json, success, failure) ->
      switch(method)
        when 'resources'
          cacheKey = method
        when 'categories'
          cacheKey = method + '_' + json.resource
        when 'tags'
          cacheKey = method + '_' + json.resource + '_' + json.category
        when 'filter'
          cacheKey = method + '_' + json.resource + '_' + json.category + '_' + (json.page || 1)
        when 'text'
          cacheKey = method + '_' + json.term + '_' + (json.page || 1)
        else
          return
      url = '/search/' + cacheKey.replace /_/g, '/'
      data =
        tags: json.tags
      
      @cacheFetch url, data, cacheKey, success, failure

    @cacheFetch = (url, data, cacheKey, success, failure) =>
      if @cache[cacheKey] && (!data.tags? || data.tags.length == 0)
        success(@cache[cacheKey])
      else
        @handle url, data, cacheKey, success, failure
    
    @handle = (url, data, cacheKey, success, failure) ->
      $.ajax
        type: 'POST'
        url: url
        data: data
        success: (json) =>
          @cache[cacheKey] = json
          success(json)
        failure: (json) ->
          failure(json)
