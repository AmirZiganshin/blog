class AddModeratedToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :moderated, :boolean
  end
end
