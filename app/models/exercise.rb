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
end
