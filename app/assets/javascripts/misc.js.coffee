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

transition_state = ->
  action = $(@)
  transition = action.data('transition')
  data =
    ops: []
    sequential: true
  method = action.data('method')
  href = action.attr('href')
  attribute = action.data('attribute')
  ids = []
  $('.check_group').filter(':checked').each ->
    params = action.data('params') || {}
    duty = $(@).parents('.duty')
    duty_id = duty.data('duty_id')
    id = duty.data(attribute)
    ids.push duty_id
    $.extend(params, duty.data('params'))
    if method == "delete"
      url = href + "/" + id
    else if method == "put"
      url = href.replace('placeholder', id)
    else
      url = href
    data["ops"].push
      method: method
      url: url
      params: params
  $.ajax
    contentType: 'application/json'
    dataType: "json"
    type: 'post'
    url: '/batch'
    data: JSON.stringify(data)
    success: (response) ->
      $.each response.results, (index) ->
        if @status == 201 || @status == 204
          id = ids[index]
          $(".duty[data-id=#{id}]").data('state')[transition](@['body'])
  return false

$ ->
  duties = $('.duty')
  duties.each ->
    state = StateMachine.create
      initial: $(@).data('state')
      events: [
        { name: 'add_preference', from: 'unassigned', to: 'rejected' },
        { name: 'add_preference', from: 'available', to: 'unavailable' },
        { name: 'add_preference', from: 'assigned', to: 'conflicted' },
        { name: 'remove_preference', from: 'rejected', to: 'unassigned' },
        { name: 'remove_preference', from: 'unavailable', to: 'available' },
        { name: 'remove_preference', from: 'conflicted', to: 'assigned' },
        { name: 'take_duty', from: 'available', to: 'assigned' }
      ],
      callbacks:
        onadd_preference: (event, from, to, params) =>
          $(@).addClass('preference')
          $(@).data('preference_id', params['id'])
          $('[data-transition=add_preference]').addClass('hide')
          $('[data-transition=remove_preference]').removeClass('hide')
          if to == "unavailable"
            $('[data-transition=take_duty]').addClass('hide')
        onremove_preference: (event, from, to, params) =>
          $(@).removeClass('preference')
          $(@).removeData('preference_id')
          $('[data-transition=add_preference]').removeClass('hide')
          $('[data-transition=remove_preference]').addClass('hide')
          if from == "unavailable"
            $('[data-transition=take_duty]').removeClass('hide')
        ontake_duty: =>
          $('[data-transition=take_duty]').addClass('hide')
        onrejected: => $(@).addClass('alert-info')
        onleaverejected: => $(@).removeClass('alert-info')
        onunavailable: => $(@).addClass('alert-info')
        onleaveunavailable: => $(@).removeClass('alert-info')
        onassigned: => $(@).addClass('alert-success')
        onleaveassigned: => $(@).removeClass('alert-success')
        onavailable: => $(@).addClass('alert-warning conflict')
        onleaveavailable: => $(@).removeClass('alert-warning conflict')
        onconflicted: => $(@).addClass('alert-error')
        onleaveconflicted: => $(@).removeClass('alert-error')
        onunassigned: => $(@).removeClass('alert')
    $(@).data('state', state)

  check_group = duties.find('.check_group')
  check_all = $('#check_all')
  checkboxes = check_group.add check_all
  last_clicked = false

  add_preference = $('[data-transition=add_preference]')
  remove_preference = $('[data-transition=remove_preference]')
  take_duty = $('[data-transition=take_duty]')

  checkboxes.attr('checked', false)
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

  add_preference.click transition_state
  remove_preference.click transition_state
  take_duty.click transition_state
