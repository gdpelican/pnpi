class @KnockoutSearchMethods
  constructor: ->
    @cache = {}

    @search = (json, success, failure) ->
      data =
        tags: json.tags
        format: 'json'
          
      @cacheFetch data, \
                  @getPostUrl(json), \
                  success, \
                  failure
    
    @tagLookup = (id) =>
      @cache[@getTagKey id]
    
    @createTagLookup = (tagList) =>
      for type in Object.keys(tagList)
        for tag in tagList[type]
          @cache[@getTagKey tag.id] = tag.tag
    
    @getTagKey = (id) ->
      @getPostUrl {type: 'tags', id: id }
      
    @getPostUrl = (json) ->
      url = json.type
      url += "/#{json.id}"        if json.type == 'tags'
      url += "/#{json.resource}"  if json.type in ['filter', 'categories']
      url += "/#{json.category}"  if json.type == 'filter'
      url += "/#{json.term}"      if json.type == 'text'
      url += "/#{json.page || 1}" if json.type in ['filter', 'text', 'all']
      url
    
    @cacheFetch = (data, postUrl, success, failure) =>
      if @cache[postUrl] && (!data.tags? || data.tags.length == 0)
        success(@cache[postUrl])
      else
        @handle data, postUrl, success, failure
    
    @handle = (data, postUrl, success, failure) ->
      $.ajax
        type: 'POST'
        url: "/search/#{postUrl}"
        data: data
        success: (json) =>
          if !json.tags? || json.tags.length == 0
            @cache[postUrl] = $.parseJSON JSON.stringify json
          success(json)
        failure: (json) ->
          failure(json)
