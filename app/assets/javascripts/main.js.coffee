$ ->
  @PNPI =
    initialize: ->
      fadeFlash = -> $('.flash').fadeOut()
      setTimeout fadeFlash, 1500
      
   @PNPI.initialize()
