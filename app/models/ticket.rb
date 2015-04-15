class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :therapy
  
  scope :with_available_entries, ->(required_date, therapy) { where("entries_remaining > 0 OR entries_remaining = -1").where(therapy: therapy).where() }
  
  def entries_available?(required_date, therapy)
    return (self.entries_remaining > 0 || self.entries_remaining == -1) && (self.activated_on + self.time_restriction) <= required_date && self.therapy == therapy
  end
  
  def register_entry(exercise)
    entry = self.entries.create(exercise: exercise)
    
    if exercise.date === self.activated_on..(self.activated_on + self.time_restriction)
      # valid
      if self.entries_remaining == -1
        # time based
      else
        # entries based
        self.entries_remaining.decrement
        self.save!
      end
    end
    
    return entry
  end
  
  validates_presence_of :time_restriction, :entries_remaining, :activated_on, :user_id, :therapy_id, :paid
end
