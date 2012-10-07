$.fn.hasAncestor = (a) ->
  @filter ->
    !!$(@).closest(a).length

preference_checkboxes = (checkboxes, add, remove) ->
  checked = $(checkboxes).filter(':checked')
  if checked.length != 0
    has_state = $(checked).hasAncestor('.preference')
    if has_state.length == checked.length
      $(add).addClass('hide')
      $(remove).removeClass('hide')
    else if has_state.length != 0
      $(add).removeClass('hide')
      $(remove).removeClass('hide')
    else
      $(add).removeClass('hide')
      $(remove).addClass('hide')
  else
    $(add).addClass('hide')
    $(remove).addClass('hide')

duty_checkboxes = (checkboxes, take) ->
  checked = $(checkboxes).filter(':checked')
  if checked.length != 0
    has_state = $(checked).hasAncestor('.conflict')
    if has_state.length != 0
      $(take).removeClass('hide')
    else
      $(take).addClass('hide')
  else
    $(take).addClass('hide')

$ ->
  check_group = $('.check_group')
  check_all = $('#check_all')
  add_preference = $('#add_preference')
  remove_preference = $('#remove_preference')
  take_duty = $('#take_duty')
  checkboxes = check_group.add check_all
  checkboxes.attr('checked', false)
  last_clicked = false
  check_all.click ->
    check_group.filter(':visible').attr('checked', @checked)
    preference_checkboxes(check_group, add_preference, remove_preference)
    duty_checkboxes(check_group, take_duty)

  check_group.change ->
    preference_checkboxes(check_group, add_preference, remove_preference)
    duty_checkboxes(check_group, take_duty)

  check_group.click (e) ->
    if last_clicked && @ != last_clicked && e.shiftKey
      start = check_group.index(@)
      end = check_group.index(last_clicked)

      check_group.slice(Math.min(start, end), Math.max(start, end) + 1).filter(':visible').attr('checked', last_clicked.checked)

    last_clicked = @

  add_preference.click (e) ->
    data = { 'ids[]' : [] }
    params = check_group.filter(':checked').parents('tr').not('.preference').find('.check_group').serialize()
    $(@).attr('href', "#{$(@).attr('href')}?#{params}")

  remove_preference.click (e) ->
    data = { 'ids[]' : [] }
    params = check_group.filter(':checked').hasAncestor('tr.preference').serialize()
    $(@).attr('href', "#{$(@).attr('href')}?#{params}")

  take_duty.click (e) ->
    data = { 'ids[]' : [] }
    params = check_group.filter(':checked').hasAncestor('tr.conflict').serialize()
    $(@).attr('href', "#{$(@).attr('href')}?#{params}")
