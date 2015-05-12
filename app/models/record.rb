class Record < ActiveRecord::Base
  belongs_to :tracked_value
  
   validates_presence_of :value, :date, :tracked_value_id
end
