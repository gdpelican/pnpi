@Knockout =
  initialize: (json) ->    
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
          
    model = new KnockoutSearch(json)  
    ko.applyBindings model

