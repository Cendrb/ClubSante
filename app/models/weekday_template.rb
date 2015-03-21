class WeekdayTemplate < ActiveRecord::Base
  belongs_to :timetable_template
  has_many :exercise_templates, dependent: :destroy
end
