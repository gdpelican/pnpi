class @KnockoutResource
  constructor: (json) ->
    @id = json.id
    @name = json.name
    @description = json.description
    @preview = json.preview
    @picture_url = json.picture_url
    @show_url = json.show_url