class DropWeekDayTemplates < ActiveRecord::Migration
  def change
    drop_table :weekday_templates
    add_column :exercise_templates, :weekday, :integer
    add_column :exercise_templates, :timetable_template_id, :integer
    remove_column :exercise_templates, :weekday_template_id
  end
end
