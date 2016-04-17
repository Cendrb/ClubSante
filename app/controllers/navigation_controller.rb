class NavigationController < ApplicationController
  before_filter :authenticate_registered
  def summary
    @data = {}
    @data[:exercises] = Exercise.joins(:exercise_modification).joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", current_user.id).where("exercise_modifications.date >= ?", Date.today).order("exercise_modifications.date")
    @data[:pending_singles] = current_user.tickets.where(single_use: true).where(paid: false)
    UserMailer.cena_mail(current_user).deliver_later
  end

  def reservations
    @data = {}
    @data[:therapies] = Therapy.order(:sorting_order)
    @data[:coaches] = Coach.valid.all
  end

  def goals
    @data = {}
    @user = current_user
    @data[:tracked_values] = @user.tracked_values
  end

  def my_account

  end

  def administration
    @data = {}
    @data[:exercises] = Exercise.joins(:exercise_modification).where("exercise_modifications.date > ?", Time.now).order("exercise_modifications.date ASC").limit(20)
    @data[:therapies] = Therapy.all
    @data[:users] = User.all
    @data[:coaches] = Coach.valid.all
    @data[:available_values] = AvailableValue.all
  end

  def reservations_ticket_view
    current_therapy = Therapy.find(params[:therapy_id])
    @data = {}
    @data[:current_therapy] = current_therapy
    @data[:tickets] = Ticket.where(single_use: false).where(user: current_user).where(therapy_category: current_therapy.therapy_categories)
  end
end
