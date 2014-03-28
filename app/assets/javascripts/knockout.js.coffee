
@Knockout =
  initialize: (json, user = false) ->
    ko.bindingHandlers.appear =
      init: (element, shown) ->
        if ko.unwrap shown()
          $(element).show()
        else
          $(element).hide()
          $(element).addClass('hide-me', true)
          
      update: (element, shown) ->
        if ko.unwrap shown()
          $(element).hide().removeClass('hide-me') if $(element).hasClass('hide-me')
          $(element).slideDown()
        else
          $(element).slideUp()
          
    ko.applyBindings new KnockoutSearch(json, user)