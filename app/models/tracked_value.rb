class TrackedValue < ActiveRecord::Base
  has_many :records, dependent: :destroy
  has_many :goals, dependent: :destroy
  belongs_to :available_value
  belongs_to :user
  
  validates_presence_of :available_value, :user_id
end
