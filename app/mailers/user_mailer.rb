class UserMailer < ApplicationMailer
  def welcome_email(user)
    @data = {}
    @data[:user] = user
    mail(to: user.smtp_address, subject: "Vítejte v rezervačním systému Club Sante")
  end
  def cena_mail(user)
    @data = {}
    @data[:user] = user
    mail(to: user.smtp_address, subject: "And his name is")
  end
  def info_mail(subject, message, email_addresses)
    @data = {}
    @data[:message] = message
    mail(bcc: email_addresses , subject: subject)
  end
end
