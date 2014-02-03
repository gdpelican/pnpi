@loadEvents ||= []
@loadEvents.push ->
  groupings = $('body.groupings, fieldset.tags')

  if groupings?
    groupings.on 'click', '.toggle-link', (event) ->
      $(@).hide().closest('.toggle-parent').find('.toggle-input').slideDown()
    
    groupings.on 'keypress', '.remote-trigger', (event) ->
      if event.keyCode == 13
        self = $(@)
        params = "name=#{self.val()}"
        if self.data('params')
          self.data('params', "#{self.data('params')}&#{params}")
        else
          self.data('params', params)
          
        $.rails.handleRemote(self)
        
    groupings.on 'ajax:success', '.remote-trigger', (event, data, xhr) ->
      parent = $(event.currentTarget).closest('.toggle-parent')
      switch data.action
        when 'create'
          parent.before(data.partial)
          parent.find('input').val('')
          parent.find('.toggle-link, .toggle-input').toggle()
          message = 'Successfully created'
        when 'update'
          parent.find('.toggle-link').html(parent.find('.toggle-input').val())
          parent.find('.toggle-link, .toggle-input').toggle()
          message = 'Successfully updated'
        when 'destroy'
          parent.slideUp()
          message = 'Successfully destroyed'
      Flash.show message, 'notice'
    
    groupings.on 'ajax:failure', '.remote-trigger', (event, data, xhr) ->
      Flash.show 'An error occurred, please try again', 'alert'