@loadEvents ||= []

@loadEvents.push ->
  @Resource =
    initialize: ->
      master = $('form.resource')
      
      master.find('input.price').number(true, 2)
      
      master.find('.choice').each ->
        if $(@).find('input[checked=checked]').length > 0
          $(@).addClass 'selected'
      
      master.on 'click', '.choice', (event) ->
        event.stopPropagation()
        $(@).toggleClass 'selected'
        check = $(@).find(':checkbox')
        check.attr('checked', !check.is(':checked'))
        false
            
      master.on 'click', '.nested-menu-link', (event) ->
        master.find('.nested-panel').show()
        showSelection $(@), event, '.nested', \
                      '.nested-resources', 'resource-type'
        
      master.on 'click', '.nested-resource-link', (event) ->
        showSelection $(@), event, '.nested-resources', \
                      '.nested-resource', 'resource-id'
      master.on 'change', 'input[type=file]', ->
        $(@).siblings('label').addClass('is-ready')
        
      master.on 'click', '.submit-link', ->
        $(@).siblings('input[type=submit]').click()
      
      master.on 'click', '.slide-to', ->
        $('html,body').animate({scrollTop: $('#' + $(@).data('target')).offset().top},'slow');
      
      showSelection = (self, event, parent, classname, datafield, target) ->
        event.stopPropagation()
        selector = "#{classname}[data-#{datafield}=#{self.data(datafield)}]"
        selected = self.closest(parent).find(selector)
        
        self.addClass('selected').siblings().removeClass('selected')
        selected.slideDown().siblings().slideUp()
        
  @Resource.initialize()