class RemoveLineIdFromPosts < ActiveRecord::Migration[6.0]
  def change

    remove_column :posts, :line_id, :string
  end
end
