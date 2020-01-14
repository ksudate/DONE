class AddRoomIdToSplints < ActiveRecord::Migration[6.0]
  def change
    add_column :splints, :room_id, :integer
  end
end
