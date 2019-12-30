class AddUserIdToSplints < ActiveRecord::Migration[6.0]
  def change
    add_column :splints, :user_id, :integer
  end
end
