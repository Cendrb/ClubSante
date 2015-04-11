class Exercise < ActiveRecord::Base
  belongs_to :timetable
  has_many :entries
  
  scope :between, ->(first, second) { where(date: first..second) }
  scope :in_future, ->() { where("date >= :today", today: Date.today) }
end
