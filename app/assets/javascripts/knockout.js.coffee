@Knockout =
  initialize: (json, user = false) ->
    ko.bindingHandlers.appear =
      init: (element, hidden) ->
        if ko.utils.unwrapObservable hidden()
          $(element).show()
        else
          $(element).hide()
      
      update: (element, hidden) ->
        if ko.utils.unwrapObservable hidden()
          $(element).slideDown()
        else
          $(element).slideUp()
          
    ko.applyBindings new KnockoutSearch(json, user)
