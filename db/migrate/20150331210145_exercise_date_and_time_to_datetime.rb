class ExerciseDateAndTimeToDatetime < ActiveRecord::Migration
  def change
    remove_column :exercises, :beginning
    remove_column :exercises, :date
    add_column :exercises, :date, :datetime
  end
end
