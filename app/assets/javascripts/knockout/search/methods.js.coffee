class @KnockoutSearchMethods
  constructor: ->
    @cache = {}

    @search = (json, success, failure) ->
      data =
        tags: json.tags
        format: 'json'
          
      @cacheFetch data, \
                  @getPostUrl(json), \
                  @getCacheKey(json), \
                  success, \
                  failure
    
    @tagLookup = (id) =>
      @cache[@getTagKey id]
    
    @createTagLookup = (tagList) =>
      for type in Object.keys(tagList)
        for tag in tagList[type]
          @cache[@getTagKey tag.id] = tag.tag
    
    @getTagKey = (id) ->
      @getCacheKey {type: 'tags', id: id }
      
    @getPostUrl = (json) ->
      url = json.type
      url += "/#{json.id}"        if json.type == 'tags'
      url += "/#{json.resource}"  if json.type in ['filter', 'categories']
      url += "/#{json.category}"  if json.type == 'filter'
      url += "/#{json.term}"      if json.type == 'text'
      url += "/#{json.page || 1}" if json.type in ['filter', 'text', 'all']
      url
    
    @getCacheKey = (json) ->
      key = @getPostUrl(json).replace(/\//g, '_') #NB: that regex is for the single '/' character 
      key += "_[#{json.tags}]"    if json.type in ['filter', 'text', 'all'] \
                                 and json.tags? and json.tags.length > 0
      key
    
    @cacheFetch = (data, postUrl, cacheKey, success, failure) =>
      if @cache[cacheKey]
        success(@cache[cacheKey])
      else
        @handle data, postUrl, cacheKey, success, failure
    
    @handle = (data, postUrl, cacheKey, success, failure) ->
      $.ajax
        type: 'POST'
        url: "/search/#{postUrl}"
        data: data
        success: (json) =>
          @cache[cacheKey] = $.extend(true, {}, json)
          success(json)
        failure: (json) ->
          failure(json)
