class RenameCarsToVehicles < ActiveRecord::Migration[5.2]
  def change
    rename_table :cars, :vehicles
  end
end
