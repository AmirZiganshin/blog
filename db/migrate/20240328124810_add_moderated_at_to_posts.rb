class AddModeratedAtToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :moderated_at, :datetime
  end
end
