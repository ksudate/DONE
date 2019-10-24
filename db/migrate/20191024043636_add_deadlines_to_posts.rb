class AddDeadlinesToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :deadline, :datetime
    add_column :posts, :rank, :string
  end
end
