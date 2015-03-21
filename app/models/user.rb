require 'digest/sha2'

class User < ActiveRecord::Base
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
end