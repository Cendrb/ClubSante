class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :therapy_category

  validates_presence_of :time_restriction, :entries_remaining, :activated_on, :user_id, :therapy_category_id
  validates_inclusion_of :single_use, in: [true, false]

  has_many :entries, dependent: :destroy

  before_create :nullout_single_user_pendings

  scope :with_available_entries, ->(required_date) {
    where("(entries_remaining > 0 OR entries_remaining = -1)")
        .where("((activated_on + (time_restriction || ' second')::interval) >= ?)", required_date)
        .where("(activated_on <= ?)", required_date)
        .where(paid: true)
        .where(single_use: false)
  }

  def nullout_single_user_pendings
    pending_single_uses = user.tickets.where(single_use: true, paid: false)
    pending_single_uses.find_each do |ticket|

    end
  end

  def entries_available?(required_date, therapy)
    return (self.entries_remaining > 0 || self.entries_remaining == -1) && required_date.between?(self.activated_on, self.activated_on + self.time_restriction) && self.therapy_category.includes?(therapy)
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
    if (self.activated_on..(self.activated_on + Time.at(self.time_restriction).to_i)).cover?(exercise.exercise_modification.date)
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

  def unregister_entry(exercise, entry, void_entry)
    entry.destroy
    if !void_entry
      if !self.paid && self.entries_remaining == 0
        # single use -> delete
        self.destroy
      else
        if self.entries_remaining == -1
          # time based
        else
          # entries based
          self.entries_remaining += 1
          self.save!
        end
      end
    end
  end

  def self.create_single_use(user, therapy)
    TherapyCategory.find_each do |category|
      if (category.therapies.count == 1 && category.therapies.first == self && category.therapies.first.can_single_use)
        ticket = Ticket.new(time_restriction: Ticket.single_use_register_date_range, entries_remaining: 1, activated_on: Date.today, paid: false, user: user, therapy_category: category, single_use: true)
        ticket.save!
        return ticket
      end
    end
    return nil
  end

  def self.for_therapy(tickets, therapy)
    tickets.drop_while { |ticket| !ticket.therapy_category.includes?(therapy) }
  end

  def self.unsubscribe_time_limit
    return 12.hours
  end

  def self.single_use_register_date_range
    return 30.days
  end
end
