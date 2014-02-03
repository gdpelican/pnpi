@loadEvents ||= []
@loadEvents.push ->
  Flash.show()
  
  $('li.phone').find('input').inputmask('(999) 999 9999')
  $('li.currency').find('input').maskMoney({ precision: 2, prefix: '$' })
  
  $('form').on 'change', 'select', ->
    $(@).toggleClass 'unselected', $(@).val() == ''
  $('form').find('select').change()
