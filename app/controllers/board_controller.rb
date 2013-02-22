class BoardController < ApplicationController
  respond_to :json

  before_filter :find_board_type, only: [:new_board, :check, :switch]
  before_filter :find_board, only: :check

  def new_board
    board_nums = @board_type.generate_nums
    @board = @board_type.find_or_create_by_board_nums(board_nums)
    render json: @board
  end

  def check
    winner = @board.check_number(index: params[:index].to_i, number: params[:number].to_i)
    render json: winner ? {winner: true} : {}
  end

  def switch
    new_board
    return
  end

  private

  def find_board_type
    type = Board.available_boards.include?(params[:board_type].to_sym) && params[:board_type] if params[:board_type]
    type ||= Board.default_board
    @board_type = eval("Board::#{type.capitalize}Board")
  end

  def find_board
    @board = @board_type.find(params[:id])
  end
end
