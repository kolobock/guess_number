# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

showBoard = (brd) ->
  $('div#board').html('<span>' + brd.id + '</span><br /><span>' + brd.board_nums + '</span>')
  tbl = '<table><tbody>'
  for nums in brd.board_nums
    tbl += '<tr>'
    for num in nums
      tbl += '<td>'
      tbl += num
      tbl += '</td>'
    tbl += '</tr>'
  tbl += '</tbody></table>'
  $(tbl).appendTo($('div#board'))
  $('div#board table td').click ->
    $(this).preventDefault
    cells = $('div#board table td').unbind('click')
    $(this).addClass('pressed')
    index = $(cells).index($(this))
    # number = $(this).context.innerText
    number = 4
    checkResult number, index


setBoardFromPath = (path) ->
  $.post(
    path
    board_type: window.board_type
    (board) ->
      window.board = {id: board.id, board_nums: board.board_nums}
      showBoard window.board
    "json"
  )

checkResult = (num, ind) ->
  $.post(
    '/board/' + window.board.id + '/check.json'
    number: num
    index: ind
    board_type: window.board_type
    (data) ->
      if data.winner != undefined
        stl = 'valid'
      else
        stl = 'invalid'
      $('div#board table td').eq(ind).addClass(stl)
  )

$ ->
  $('div#board_types')
    .find('input[type=radio]').change ->
      $(this).preventDefault
      window.board_type = $(this).val()
      setBoardFromPath '/board/switch'

  $('div#board_types')
    .find('button').click ->
      $(this).preventDefault
      setBoardFromPath '/board/new_board'

  window.board_type = $('div#board_types input[type=radio]:checked').val()
  $('div#board_types button').trigger('click')

