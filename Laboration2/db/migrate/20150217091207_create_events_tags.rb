class CreateEventsTags < ActiveRecord::Migration
  def change
    create_table :events_tags do |t|
      t.belongs_to :tag
      t.belongs_to :event
    end
  end
end
