class AddBoardNumsToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :board_nums, :string
  end
end
