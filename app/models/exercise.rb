class Exercise < ActiveRecord::Base
  belongs_to :timetable
  
  scope :between, ->(first, second) { where(date: first..second) }
  scope :in_future, ->() { where("date >= :today", today: Date.today) }
end
