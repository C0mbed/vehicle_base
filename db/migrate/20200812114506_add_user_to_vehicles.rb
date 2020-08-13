class AddUserToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :user_id, :integer
  end
end
