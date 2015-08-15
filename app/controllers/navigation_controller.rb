class NavigationController < ApplicationController
  def summary
    @data = {}
    @data[:exercises] = Exercise.joins(:exercise_modification).joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", current_user.id).where("exercise_modifications.date >= ?", Date.today).order("exercise_modifications.date")
    @data[:pending_singles] = current_user.tickets.where(single_use: true).where(paid: false)
  end

  def reservations
    redirect_to calendar_summary_path
  end

  def tickets
    @tickets = current_user.tickets.where(single_use: false)
  end

  def goals
    @data = {}
    @user = current_user
    @data[:tracked_values] = @user.tracked_values
  end

  def administration
    @data = {}
    @data[:exercises] = Exercise.joins(:exercise_modification).where("exercise_modifications.date > ?", Time.now).order("exercise_modifications.date DESC").limit(20)
    @data[:therapies] = Therapy.all
    @data[:users] = User.all
    @data[:coaches] = Coach.valid.all
  end
end
