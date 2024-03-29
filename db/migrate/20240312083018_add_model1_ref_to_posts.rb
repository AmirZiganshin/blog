class AddModel1RefToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :model1, foreign_key: true
  end
end
