class Exercise < ActiveRecord::Base
  belongs_to :timetable
  has_many :entries, dependent: :destroy
  
  has_one :therapy, through: [:timetable_template, :calendar, :therapy]
  
  
  scope :between, ->(first, second) { where(date: first..second) }
  scope :in_future, ->() { where("date >= :today", today: Date.today) }
  
  def full?
    return self.timetable.calendar.therapy.capacity <= self.entries.count
  end
  
  def signed_up?(user)
    return self.entries.joins(:ticket).where(tickets: { user_id: user.id }).count > 0
  end
  
  def get_capacity_string
    return "obsazeno #{self.entries.count} z #{self.timetable.calendar.therapy.capacity}"
  end
  
  def get_beginning_string
    return self.date.to_s(:time)
  end
  
  def get_time_range_string
    return "#{get_beginning_string} - #{(self.date + self.timetable.calendar.therapy.duration_in_minutes.minutes).to_s(:time)}"
  end
  
  def get_duration_string
    return "#{self.timetable.calendar.therapy.duration_in_minutes} minut"
  end
end
