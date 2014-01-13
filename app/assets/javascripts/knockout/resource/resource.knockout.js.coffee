class @KnockoutResource
  constructor: (json, user) ->
    @id = json.id
    @type = json.type.toLowerCase()
    @name = json.name
    @description = json.description
    @preview = json.preview
    @pictureUrl = json.picture_url
    @tags = json.tags.slice(0,4)
    @previewClass = @type + '-wrapper resource-wrapper'
    @showUrl = json.show_url
    @showResource = ->
      if user
        window.location.href = @showUrl
