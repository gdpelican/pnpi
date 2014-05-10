class @KnockoutResource
  constructor: (json, user) ->
    @id = json.id
    @type = json.type.toLowerCase()
    @name = json.name
    @description = json.description
    @descriptionClamped = "#{json.description.substring(0, 100)}" + \
                          "#{if json.description.length > 100 then '...' else ''}"
    @preview = json.preview
    @previewQuote = if json.preview and json.type == 'Person'
                      "\"#{json.preview}\"" 
                    else 
                      json.preview
    @pictureUrl = json.picture_url
    @tags = json.tags.slice(0,4)
    @previewClass = @type + '-wrapper resource-wrapper'
    @showUrl = json.show_url
    @user = user
