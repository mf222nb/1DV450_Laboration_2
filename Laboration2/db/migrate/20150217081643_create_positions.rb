class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :long
      t.string :lat
      t.timestamps
    end
  end
end
