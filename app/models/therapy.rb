class Therapy < ActiveRecord::Base
  has_one :calendar, dependent: :destroy
  has_and_belongs_to_many :therapy_categories

  validates_presence_of :name, :capacity, :duration_in_minutes
  validates_inclusion_of :can_single_use, in: [true, false]
  before_create :init_dependent

  def init_dependent
    begin
      self.calendar = Calendar.create!
    rescue => e
      puts "zidan #{e.class.name} : #{e.message}"
    end
    true
  end

  def can_single_use_meth
    TherapyCategory.find_each do |category|
      if (category.therapies.count == 1 && category.therapies.first == self && category.therapies.first.can_single_use)
        return true
      end
    end
    return false
  end
end
