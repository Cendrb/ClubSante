class EntryValidator < ActiveModel::Validator
  def validate(record)
    #unless record.ticket.entries_available?(record)
    #  record.errors[:ticket] << "Na zvolené kartě není dostatek vstupů nebo již skončila její platnost"
    #end
    unless record.exercise.entries.count < record.exercise.timetable.calendar.therapy.capacity && record.exercise.available
      record.errors[:exercise] << "Kapacita zvoleného cvičení byla dosažena"
    end
  end
end

class Entry < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :exercise
  has_one :user, through: :ticket
  
  include ActiveModel::Validations
  validates_with EntryValidator
  
  validates_presence_of :exercise_id, :ticket_id

  after_destroy :destroy_exercise_if_empty

  def destroy_exercise_if_empty
    if (exercise.entries.count == 0)
      exercise.destroy!
      if (!exercise.exercise_modification.differs_from_template?)
        exercise.exercise_modification.exercise_template = exercise.exercise_modification.exercise_template
        exercise.exercise_modification.destroy!
      end
    end
  end
end
