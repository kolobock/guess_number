class AddIndexToTypeOfBoards < ActiveRecord::Migration
  def change
    add_index :boards, :type
  end
end
