class Timetable < ActiveRecord::Base
  belongs_to :calendar
  has_many :exercise_days, dependent: :destroy
end
