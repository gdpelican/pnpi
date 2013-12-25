@loadEvents ||= []
@loadEvents.push ->
  fadeFlash = -> $('.flash').fadeOut()
  setTimeout fadeFlash, 2500