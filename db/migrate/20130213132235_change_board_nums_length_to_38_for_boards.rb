class ChangeBoardNumsLengthTo38ForBoards < ActiveRecord::Migration
  def up
    change_column :boards, :board_nums, :string, limit: 38, null: false
  end

  def down
    change_column :boards, :board_nums, :string, null: true
  end
end
