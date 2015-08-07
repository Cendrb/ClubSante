class TimetableModification < ActiveRecord::Base
  has_many :exercise_modifications, dependent: :destroy
  belongs_to :calendar
end
