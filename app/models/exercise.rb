class Exercise < ActiveRecord::Base
  belongs_to :timetable
  has_many :entries
  
  def signup_with(ticket)
    self.entries.add(ticket.register_entry(self))
  end
  
  has_one :therapy, through: [:timetable_template, :calendar, :therapy]
  
  
  scope :between, ->(first, second) { where(date: first..second) }
  scope :in_future, ->() { where("date >= :today", today: Date.today) }
end
