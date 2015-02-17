class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.references :user
      t.string :key, unique:true
      t.timestamps
    end
  end
end
