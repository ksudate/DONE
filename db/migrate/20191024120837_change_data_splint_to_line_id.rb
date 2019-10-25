class ChangeDataSplintToLineId < ActiveRecord::Migration[6.0]
  def change
    change_column :splints, :line_id, :string
  end
end
