class AddModel1RefToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :model1, foreign_key: true
  end
end
