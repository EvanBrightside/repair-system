class RemoveFloorAndUnitPlansFromApartments < ActiveRecord::Migration[5.2]
  def change
    remove_column :apartments, :floor_plan, :string
    remove_column :apartments, :unit_plans, :json
  end
end
