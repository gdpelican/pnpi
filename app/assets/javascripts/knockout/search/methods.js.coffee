class @KnockoutSearchMethods
  constructor: ->
    @cache = {}

    @fetch = (json, success, failure) =>
      data = 
        tags: json.tags
        format: 'json'
      cacheKey = @getCacheKey json
      
      if @cache[cacheKey]
        success($.parseJSON @cache[cacheKey])
      else
        @handle data, @getPostUrl(json), success, failure
    
    @fetchTag = (id) =>
      @fetch({ type: 'tags', id: id }, (json) -> json.tag )
      
    @store = (json) =>
      @cache[@getCacheKey json] = JSON.stringify json

    @createTagLookup = (tagList) =>
      for type in Object.keys(tagList)
        for tag in tagList[type]
          @store { type: 'tags', id: tag.id, tag: tag.tag }
    
    @getPostUrl = (json) ->
      url = json.type
      url += "/#{json.id}"        if json.type == 'tags'
      url += "/#{json.resource}"  if json.type in ['filter', 'categories']
      url += "/#{json.category}"  if json.type == 'filter'
      url += "/#{json.term}"      if json.type == 'text'
      url += "/#{json.page || 1}" if json.type in ['filter', 'text', 'all']
      url
    
    @getCacheKey = (json) ->
      key = @getPostUrl(json).replace(/\//g, '_')
      if json.tags? && json.tags.length > 0
        key += "_[#{json.tags}]"
      key
    
    @handle = (data, postUrl, success, failure) ->
      $.ajax
        type: 'POST'
        url: "/search/#{postUrl}"
        data: data
        success: (json) =>
          @store json
          success(json)
        failure: (json) ->
          failure(json)
