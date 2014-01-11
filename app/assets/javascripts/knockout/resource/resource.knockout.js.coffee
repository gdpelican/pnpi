class @KnockoutResource
  constructor: (json) ->
    @id = json.id
    @type = json.type.toLowerCase()
    @name = json.name
    @description = json.description
    @preview = json.preview
    @picture_url = json.picture_url
    @show_url = json.show_url
    @tags = json.tags.slice(0,4)
    @previewClass = @type + '-wrapper resource-wrapper'
