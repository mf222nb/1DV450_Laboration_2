class CreateCreators < ActiveRecord::Migration
  def change
    create_table :creators do |t|
      t.string :name
      t.string :password_digest
      t.timestamps
    end
  end
end
