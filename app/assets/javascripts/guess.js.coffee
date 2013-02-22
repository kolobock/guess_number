# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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

setBoardFromPath = (path) ->
  $.post(
    path
    board_type: window.board_type
    (board) ->
      window.board = {id: board.id, board_nums: board.board_nums}
      showBoard window.board
    "json"
  )

showBoard = (brd) ->
  $('div#guess').addClass('hidden')
  tbl = '<table><tbody>'
  for nums in brd.board_nums
    tbl += '<tr>'
    for num in nums
      tbl += '<td>'
      tbl += num
      tbl += '</td>'
    tbl += '</tr>'
  tbl += '</tbody></table>'
  $('div#board').html(tbl)
  $('div#board table td').click ->
    $(this).preventDefault
    cells = $('div#board table td').unbind('click')
    $(this).addClass('pressed')
    checkResult $(cells).index($(this))
  sort = setInterval ( ->
    startSort()
  ), 100
  setTimeout ->
    stopSort sort
  , 5000

startSort = ->
  tds = $('div#board table td')
  hint_cell = $(tds).eq(Math.floor(Math.random() * tds.length))
  $(tds).removeClass()
  $(hint_cell).addClass('show')
  $(tds).not($(hint_cell)).addClass('sort')

stopSort = (interval) ->
  tds = $('div#board table td')
  clearInterval(interval)
  $(tds).removeClass()
  window.number = $(tds).eq(Math.floor(Math.random() * tds.length)).text()
  $('div#guess').removeClass('hidden').find('span#number').text(window.number)

checkResult = (ind) ->
  $.post(
    '/board/' + window.board.id + '/check.json'
    number: window.number
    index: ind
    board_type: window.board_type
    (data) ->
      if data.winner != undefined
        stl = 'valid'
      else
        stl = 'invalid'
      $('div#board table td').addClass('show').eq(ind).addClass(stl)
  )

