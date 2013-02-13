class AddTypeToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :type, :string
  end
end
