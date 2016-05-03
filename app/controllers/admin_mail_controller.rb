class AdminMailController < ApplicationController
  def index
  end

  def form_to_access_level

  end

  def send_to_access_level
    @data = {}
    @data[:subject] = params[:subject]
    @data[:message] = params[:message]
    users = User.where('access_level IN (?)', params[:access_levels])
    @data[:addresses] = users.pluck(:email)
    UserMailer.info_mail(@data[:subject], @data[:message], @data[:addresses]).deliver_later
    render 'admin_mail/mails_sent'
  end

  def form_to_user

  end

  def send_to_user
    @data = {}
    @data[:subject] = params[:subject]
    @data[:message] = params[:message]
    users = User.where('id IN (?)', params[:users])
    @data[:addresses] = users.pluck(:email)
    UserMailer.info_mail(@data[:subject], @data[:message], @data[:addresses]).deliver_later
    render 'admin_mail/mails_sent'
  end
end
