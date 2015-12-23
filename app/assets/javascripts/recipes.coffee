# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # row_order に連番を振る
  numbering_row_order = (list) ->
    items = list.find('div.item:visible')
    i = 1
    items.each ->
      item = $(this)
      item.find('span.row_order').html(i)
      item.find('input:hidden.row_order').val(i++)

  # アイテムが２つ以上ある場合のみ、削除リンクとSortableを有効にする
  switch_delete_links_and_sortable = (list) ->
    items = list.find('div.item:visible')
    items.each ->
      item = $(this)
      if items.length == 1
        item.find('.remove_field').hide()
        list.sortable
          disabled: true
      else
        item.find('.remove_field').show()
        list.sortable
          disabled: false
          axis: 'y'
          items: '.item'
          update: (e, ui) ->
            items = $(this)
            numbering_row_order(items)

  # ファイル入力に bootstrap filestyle を適用する
  # js で追加した分にスタイルを適用することが目的
  apply_filestyle = ->
    $('.filestyle').each ->
      $this = $(this)
      options =
        'input': if $this.attr('data-input') == 'false' then false else true
        'icon': if $this.attr('data-icon') == 'false' then false else true
        'buttonBefore': if $this.attr('data-buttonBefore') == 'true' then true else false
        'disabled': if $this.attr('data-disabled') == 'true' then true else false
        'size': $this.attr('data-size')
        'buttonText': $this.attr('data-buttonText')
        'buttonName': $this.attr('data-buttonName')
        'iconName': $this.attr('data-iconName')
        'badge': if $this.attr('data-badge') == 'false' then false else true
        'placeholder': $this.attr('data-placeholder')
      $this.filestyle options

  # フィールド追加のクリックイベントハンドラ
  $('form').on 'click', '.add_field', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    items = $(this).closest('.items')
    switch_delete_links_and_sortable(items)
    numbering_row_order(items)
    apply_filestyle()
    event.stopPropagation() # これを入れないと（ステップの方は）2回ハンドラが走ってしまう
    event.preventDefault() # デフォルトの処理（この場合はsubmitに対して）をキャンセルする処理

  # フィールド削除のクリックイベントハンドラ
  $('form').on 'click', '.remove_field', (event) ->
    $(this).prev('input[name*=_destroy]').val('true')
    $(this).closest('div.item').hide()

    items = $(this).closest('.items')
    switch_delete_links_and_sortable(items)
    numbering_row_order(items)

    event.preventDefault() # デフォルトの処理（この場合はクリックに対して）をキャンセルする処理

  # thumbnail 要素の高さを一括して揃える
  $('.thumbnail').matchHeight()

  # 削除リンクとSortableの初期処理
  $('div.items').each ->
    item = $(this)
    switch_delete_links_and_sortable(item)
