class CreateTimetableTemplates < ActiveRecord::Migration
  def change
    create_table :timetable_templates do |t|
      t.integer :calendar_id

      t.timestamps null: false
    end
  end
end
