class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :area_dimension
      t.string :status
      t.references :apartment, foreign_key: true

      t.timestamps
    end
  end
end
