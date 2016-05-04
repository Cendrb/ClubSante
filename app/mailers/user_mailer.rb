class UserMailer < ApplicationMailer
  def welcome_email(user)
    @data = {}
    @data[:user] = user
    @data[:link] = @data[:user].generate_activation_link
    mail(to: user.smtp_address, subject: 'Aktivace účtu Club Sante')
  end
  def cena_mail(user)
    @data = {}
    @data[:user] = user
    mail(to: user.smtp_address, subject: 'And his name is')
  end
  def info_mail(subject, message, email_addresses)
    @data = {}
    @data[:message] = message
    mail(bcc: email_addresses , subject: subject)
  end
  def forgot_password(user)
    @data = {}
    @data[:link] = user.generate_forgot_password_link
    mail(to: user.email, subject: 'Zapomenuté heslo')
  end
end
