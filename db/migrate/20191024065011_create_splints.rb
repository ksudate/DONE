class CreateSplints < ActiveRecord::Migration[6.0]
  def change
    create_table :splints do |t|
      t.integer :sp_number
      t.string :content
      t.string :kpt
      t.integer :line_id

      t.timestamps
    end
  end
end
