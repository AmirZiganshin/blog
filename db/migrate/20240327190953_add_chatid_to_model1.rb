class AddChatidToModel1 < ActiveRecord::Migration[6.1]
  def change
    add_column :model1s, :chatid, :string, default: nil
  end
end
