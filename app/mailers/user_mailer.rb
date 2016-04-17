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
end
