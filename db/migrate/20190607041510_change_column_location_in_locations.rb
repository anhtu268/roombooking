class ChangeColumnLocationInLocations < ActiveRecord::Migration[5.2]
  def change
    remove_column :locations, :location
    add_column :locations, :address, :string
  end
end
