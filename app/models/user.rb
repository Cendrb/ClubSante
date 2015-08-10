require 'digest/sha2'

class User < ActiveRecord::Base
  has_many :tickets
  has_many :tracked_values
  
  validates :email, presence: true, uniqueness: true #, email_format: {message: 'není platný email'}
  validates :password, confirmation: true
  validate :password_must_be_present
  
  attr_accessor :password_confirmation
  attr_reader :password
  
  def password=(password)
    @password = password
    
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  def full_name
    return "#{first_name} #{last_name}"
  end
  
  def access_for_level?(required_level)
    return access_level >= required_level
  end
  

  private
  def password_must_be_present
    errors.add(:password, "chybí") unless hashed_password.present?
  end
  
  private
  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  # Static
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "95azVJE3c1" + salt)
  end
  
  def User.authenticate(email, password)
    if user = find_by_email(email)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
  
  def User.validate_date_signup(date)
    if date < Date.today
      return "Nemůžete si rezervovat datum v minulosti"
    end
    return true
  end
  
  def User.validate_exercise_signup(exercise, user)
    result = validate_date_signup(exercise.date)
    if result != true
      return result
    end
    
    if exercise.signed_up?(user)
      return "Nemůžete se přihlásit na jedno cvičení vícekrát"
    end
    
    if exercise.full?
      return "Kapacita tohoto cvičení byla již dosažena (#{exercise.timetable.calendar.therapy.capacity})"
    end
    return true
  end
  
  # Constants
  def User.al_admin
    return 10
  end
  
  def User.al_customer
    return 8
  end
  
  def User.al_registered
    return 5
  end
  
  def User.access_levels
    return %w(registrovaný zákazník administrátor)
  end
  
  def User.get_access_level_string(number)
    case number
    when User.al_registered
      return "registrovaný"
    when User.al_customer
      return "zákazník"
    when User.al_admin
      return "administrátor"
    end
  end
  
  def User.parse_access_level(string)
    case string
    when "registrovaný"
      return User.al_registered
    when "zákazník"
      return User.al_customer
    when "administrátor"
      return User.al_admin
    end
  end
end
