class ChangeBoardNumsLengthOfBoards < ActiveRecord::Migration
  def up
    change_column :boards, :board_nums, :string, limit: 15, null: false
  end

  def down
    change_column :boards, :board_nums, :string, null: true
  end
end
