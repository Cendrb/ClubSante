class ExerciseDay < ActiveRecord::Base
  belongs_to :timetable
  has_many :exercises, dependent: :destroy
end
