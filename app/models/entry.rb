class Entry < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :exercise
  has_one :user, through: :ticket
  
  validate_presence_of :exercise_id, :ticket_id
end
