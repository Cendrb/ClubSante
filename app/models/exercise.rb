class Exercise < ActiveRecord::Base
  validates_presence_of :timetable_id, :exercise_modification_id
  validates_uniqueness_of :exercise_modification_id
  belongs_to :timetable
  
  belongs_to :exercise_modification
  
  has_many :entries, dependent: :destroy
  
  has_one :therapy, through: [:timetable_template, :calendar, :therapy]
  
  
  scope :between, ->(first, second) { joins(:exercise_modification).where('exercise_modifications.date' => first..second) }
  scope :in_future, ->() { joins(:exercise_modification).where("exercise_modifications.date >= :today", today: Date.today) }
  
  def full?
    return self.timetable.calendar.therapy.capacity <= self.entries.count
  end
  
  def signed_up?(user)
    return self.entries.joins(:ticket).where(tickets: { user_id: user.id }).count > 0
  end
end
