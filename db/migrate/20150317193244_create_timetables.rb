class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.belongs_to :calendar, index: true

      t.timestamps null: false
    end
  end
end
