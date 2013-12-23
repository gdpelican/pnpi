$ ->
  @Resource =
    initialize: ->
      master = $('form.resource')      
      master.find('input.price').number(true, 2)
      master.find('.choice').each ->
        if $(@).find('input[checked=checked]').length > 0
          $(@).addClass 'selected'
      
      masterForm = master.not('.readonly')
      masterForm.on 'click', '.choice', (event) ->
        event.stopPropagation()
        $(@).toggleClass 'selected'
        check = $(@).find(':checkbox')
        check.attr('checked', !check.is(':checked'))
        false
          
  @Resource.initialize()
