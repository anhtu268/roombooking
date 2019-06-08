class AddForeignKeyToReservations < ActiveRecord::Migration[5.2]
  def change
    change_table :reservations do |t|
      t.references :location, foreign_key: true
    end
  end
end
