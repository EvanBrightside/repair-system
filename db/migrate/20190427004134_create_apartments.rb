class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :owner
      t.string :property_name
      t.string :property_developer
      t.string :address
      t.string :status
      t.string :number_of_rooms
      t.integer :floor
      t.integer :area_dimension

      t.timestamps
    end
  end
end
