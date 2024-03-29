class AddRolesToModel1 < ActiveRecord::Migration[6.1]
  def change
    add_column :model1s, :role, :integer, default: 0
  end
end
