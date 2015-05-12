class AvailableValue < ActiveRecord::Base
  has_many :tracked_values, dependent: :destroy
  
   validates :name, presence: true, uniqueness: true
end
