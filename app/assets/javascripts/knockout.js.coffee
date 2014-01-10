@Knockout =
  initialize: (json, user) ->
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
    
    resources =
      resources: json.results
    ko.applyBindings new KnockoutSearch(resources, user)

