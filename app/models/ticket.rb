class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :therapy
  
  has_many :entries, dependent: :destroy
  
  scope :with_available_entries, ->(therapy, required_date) { 
    where("(entries_remaining > 0 OR entries_remaining = -1)").where(therapy: therapy)
    .where("((activated_on + (time_restriction || ' second')::interval) >= ?)", required_date)
    .where("(activated_on <= ?)", required_date)
    .where(therapy: therapy)
    .where(paid: true) }
  
  def entries_available?(required_date, therapy)
    puts activated_on.class
    return (self.entries_remaining > 0 || self.entries_remaining == -1) && required_date.between?(self.activated_on, self.activated_on + self.time_restriction) && self.therapy == therapy
  end
  
  def register_entry(exercise)
    if (self.activated_on..(self.activated_on + Time.at(self.time_restriction).to_i)).cover?(exercise.date)
      # valid
      entry = self.entries.create(exercise: exercise)
      if self.entries_remaining == -1
        # time based
      else
        # entries based
        self.entries_remaining -= 1
        self.save!
      end
    end
    
    return entry
  end
  
  validates_presence_of :time_restriction, :entries_remaining, :activated_on, :user_id, :therapy_id, :paid
end
