class Timetable < ActiveRecord::Base
  belongs_to :calendar
  has_many :exercises, dependent: :destroy
end
