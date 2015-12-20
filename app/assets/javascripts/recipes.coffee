# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  $('.thumbnail').matchHeight();

  number_list = (list) ->
    items = list.find('div.item:visible')
    i = 1
    items.each ->
      item = $(this)
      item.find('span.row_order').html(i)
      item.find('input:hidden.row_order').val(i++)

  switch_delete_links = (list) ->
    items = list.find('div.item:visible')
    items.each ->
      item = $(this)      
      if items.length == 1 
        item.find('.remove_field').hide()
      else
        item.find('.remove_field').show()

  $('div.items').each ->
    item = $(this)
    switch_delete_links(item)
    
  $('form').on 'click', '.add_field', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    items = $(this).closest('div.items')
    
    switch_delete_links(items)
    number_list(items)
    event.preventDefault() # デフォルトの処理（この場合はクリックに対して）をキャンセルする処理
    
  $('form').on 'click', '.remove_field', (event) ->
    $(this).prev('input[name*=_destroy]').val('true')
    $(this).closest('div.item').hide()
  
    switch_delete_links($(this).closest('.items'))
    number_list($(this).closest('.items'))
  
    event.preventDefault() # デフォルトの処理（この場合はクリックに対して）をキャンセルする処理
    
  $('.sortable').sortable
    axis: 'y'
    items: '.item'
    update: (e, ui) ->
      number_list($(this))
  
