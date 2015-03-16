class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :creator
      t.references :position
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
