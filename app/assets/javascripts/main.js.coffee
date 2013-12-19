ready = ->
  fadeFlash = -> $('.flash').fadeOut()
  setTimeout fadeFlash, 2500

$(document).on 'page:load', ready
$(document).ready ready