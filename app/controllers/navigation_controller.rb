class NavigationController < ApplicationController
  before_filter :authenticate_registered, except: :update
  def summary
    @data = {}
    @data[:exercises] = Exercise.joins(:exercise_modification).joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", current_user.id).where("exercise_modifications.date >= ?", Date.today).order("exercise_modifications.date")
    @data[:pending_singles] = current_user.tickets.where(single_use: true).where(paid: false)
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
    max_date = params[:ticket_max_date]
    @data = {}
    @data[:current_therapy] = current_therapy
    @data[:tickets] = Ticket.with_available_entries(Date.parse(max_date)).where(user: current_user).where(therapy_category: current_therapy.therapy_categories)
  end

  def update
    render nothing: true
  end
end
