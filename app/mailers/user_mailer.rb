class UserMailer < ApplicationMailer
  def welcome_email(user)
    @data = {}
    @data[:user] = user
    mail(to: user.email, subject: "Vítejte v rezervačním systému Club Sante")
  end
end
