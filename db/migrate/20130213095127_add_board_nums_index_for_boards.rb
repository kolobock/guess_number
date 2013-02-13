class AddBoardNumsIndexForBoards < ActiveRecord::Migration
  def change
    add_index :boards, [:type, :board_nums]
  end
end
