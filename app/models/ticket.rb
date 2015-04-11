class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :therapy
  
  def entries_available?(required_date)
    return (self.entries_remaining > 0 || self.entries_remaining == -1) && (self.activated_on + self.time_restriction) <= required_date
  end
  
  def register_entry(exercise)
    entry = self.entries.create(exercise: exercise)
    
    if (self.activated_on + self.time_restriction) <= exercise.date
      # valid
      if self.entries_remaining == -1
        # time based
      else
        self.entries_remaining.decrement
        self.save!
      end
    end
    
    return entry
  end
  
  validates_presence_of :time_restriction, :entries_remaining, :activated_on, :user_id, :therapy_id, :paid
end
