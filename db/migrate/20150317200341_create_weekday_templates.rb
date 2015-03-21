class CreateWeekdayTemplates < ActiveRecord::Migration
  def change
    create_table :weekday_templates do |t|
      t.integer :weekday
      t.integer :timetable_template_id

      t.timestamps null: false
    end
  end
end
