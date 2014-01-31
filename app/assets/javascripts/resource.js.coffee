@loadEvents ||= []

@loadEvents.push ->
  @Resource =
    initialize: ->
      show = $('article.resource')
      if show?
        show.on 'click', '.toggle-trigger', ->
          _this = $(@)
          parent = _this.closest 'section'
          data = _this.data 'target'
          target = parent.find ".toggle-target[data-target=#{data}]"
          target.slideToggle()
          _this.find('.fa-plus, .fa-minus').toggleClass 'fa-plus fa-minus'
      
      form = $('form.resource')
      if form?
        form.find('li.tag').each ->
          if $(@).find('input[checked=checked]').length > 0
            $(@).addClass 'selected'
        
        form.on 'click', 'li.tag', (event) ->
          event.stopPropagation()
          $(@).toggleClass 'selected'
          check = $(@).find(':checkbox')
          check.attr('checked', !check.is(':checked'))
          false
              
        form.on 'click', '.nested-menu-link', (event) ->
          form.find('.nested-panel').show()
          showSelection $(@), event, '.nested', \
                        '.nested-resources', 'resource-type'

        form.on 'change', 'input[type=file]', ->
          $(@).siblings('label').addClass('is-ready')
          
        form.on 'click', '.submit-link', ->
          $(@).siblings('input[type=submit]').click()
        
        form.on 'click', '.deactivate-link', ->
          $(@).closest('form.resource').find('.active').val(false)
          $(@).siblings('input[type=submit]').click()
        
        form.on 'click', '.slide-to', ->
          $('html,body').animate(\
            {scrollTop: $('#' + $(@).data('target')).offset().top},'slow')
        
        form.on 'click', '.tooltip ol a', ->
          $(this).closest('li').slideUp().next('li').slideDown()
        
        showSelection = (self, event, parent, classname, datafield, target) ->
          event.stopPropagation()
          selector = "#{classname}[data-#{datafield}=#{self.data(datafield)}]"
          selected = self.closest(parent).find(selector)
          
          self.addClass('selected').siblings().removeClass('selected')
          selected.slideDown().siblings().slideUp()
        
  @Resource.initialize()