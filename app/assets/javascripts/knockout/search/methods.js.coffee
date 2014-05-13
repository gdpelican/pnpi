class @KnockoutSearchMethods
  constructor: ->
    @cache = {}

    @fetchSearch = (json, success, failure) =>
      cacheKey = @getCacheKey json
      postUrl = @getPostUrl json
      data =
        tags:      json.tags
        format:    'json'
      @fetch cacheKey, postUrl, data, success, failure
      
    @fetchTag = (id) =>
      @fetch("tags_#{id}", "tags/#{id}", null, (json) -> json.tag)
    
    @fetchDirect = (cacheKey, success, failure) =>
      tagRegex = /\[(.*)\]/g
      tags = tagRegex.exec cacheKey
      data =
        tags:       if tags? then tags[1].split(',') else []
        cache_key:  cacheKey
        format:     'json'
      @fetch cacheKey, cacheKey.replace(/_/g, '/').replace(tagRegex, ''), data, success, failure
    
    @fetch = (cacheKey, postUrl, data, success, failure, repeat = true) =>
      if @cache[cacheKey]
        success($.parseJSON @cache[cacheKey])
        #$.post("/search/touch/#{cacheKey}")
      else
        @handle(data, postUrl, success, failure).then =>
          @fetch cacheKey, postUrl, data, success, failure, false if repeat
    
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
