class TimetableTemplate < ActiveRecord::Base
  belongs_to :calendar
  has_many :exercise_templates, dependent: :destroy
end
