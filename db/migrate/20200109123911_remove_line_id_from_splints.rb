class RemoveLineIdFromSplints < ActiveRecord::Migration[6.0]
  def change

    remove_column :splints, :line_id, :string
  end
end
