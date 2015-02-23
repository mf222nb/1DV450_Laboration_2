class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.float :long, :precision => 10, :scale => 6
      t.float :lat, :precision => 10, :scale => 6
      t.timestamps
    end
  end
end
