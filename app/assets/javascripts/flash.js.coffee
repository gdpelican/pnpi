@Flash = 
  show: (message='', type='notice', delay=2500) ->
    flash = $('.flash')
    message = flash.html() unless message?.length

    flash.addClass(type).html(message).fadeIn() if message?.length
    setTimeout @hide, delay
    
  hide: ->
    $('.flash').fadeOut ->
      $(@).removeClass().addClass('flash')