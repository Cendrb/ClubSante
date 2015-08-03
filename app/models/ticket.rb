class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :therapy_category
  
  has_many :entries, dependent: :destroy
  
  scope :with_available_entries, ->(therapy, required_date) { 
    where("(entries_remaining > 0 OR entries_remaining = -1)").where(therapy: therapy)
    .where("((activated_on + (time_restriction || ' second')::interval) >= ?)", required_date)
    .where("(activated_on <= ?)", required_date)
    .where(therapy: therapy)
    .where(paid: true) }
  
  def entries_available?(required_date, therapy)
    puts activated_on.class
    return (self.entries_remaining > 0 || self.entries_remaining == -1) && required_date.between?(self.activated_on, self.activated_on + self.time_restriction) && self.therapy_category.includes?(therapy) && self.paid
  end
  
  def get_entries_unavailable_error(required_date, therapy)
    if !self.paid
      return "permanentka není zaplacená"
    end
    
    if !(self.entries_remaining > 0 || self.entries_remaining == -1)
      return "nedostatek vstupů"
    end
    
    if !required_date.between?(self.activated_on, self.activated_on + self.time_restriction)
      return "platnost vypršela"
    end
    
    if !self.therapy_category.includes?(therapy)
      return "nelze použít pro rezervaci #{therapy.name.downcase}"
    end
    
    return "žádné chyby nenalezeny"
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
  
  def unregister_entry(exercise, entry)
    entry.destroy
    if self.entries_remaining == -1
        # time based
      else
        # entries based
        self.entries_remaining += 1
        self.save!
      end
  end
  
  def self.unsubscribe_time_limit
    return 24.hours
  end
  
  validates_presence_of :time_restriction, :entries_remaining, :activated_on, :user_id, :therapy_category_id, :paid
end
