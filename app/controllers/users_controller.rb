class UsersController < ApplicationController
  before_filter :authenticate_admin, only: [:index, :admin_edit, :admin_update, :show, :administration]
  before_filter :authenticate_registered, only: [:summary]
  before_filter :self_edit?, only: [:edit, :update, :destroy, :tracked_value_chart]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :admin_edit, :admin_update]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end
  
  def tracked_value_chart
    tracked_value = TrackedValue.find(params[:tracked_value_id])
    
    records = Record.select("date, avg(value) as avg_value").group("date").where(tracked_value: tracked_value)
    records = records.map{ |counter| [ counter[:date], counter[:avg_value] ] }
    records = {name: "Zaznamenaná hodnota", data: records}
    
    goals = Goal.select("date, avg(value) as avg_value").group("date").where(tracked_value: tracked_value)
    goals = goals.map{ |counter| [ counter[:date], counter[:avg_value] ] }
    goals = {name: "Zadaný cíl", data: goals}
    
    result = []
    result << records
    result << goals
    puts result
    render json: result.chart_json
  end
  
  def summary
    user = current_user
    @tickets = user.tickets.where(single_use: false)
    @exercises = Exercise.joins(:exercise_modification).joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", user.id).where("exercise_modifications.date >= ?", Date.today).order("exercise_modifications.date")
    @user = user
    @pending_singles = user.tickets.where(single_use: true).where(paid: false)
  end
  
  def admin_summary
    if(params[:id] && access_for_level?(User.al_admin))
      user = User.find(params[:id])
      @tickets = user.tickets
      @exercises = Exercise.joins(:exercise_modification).joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", user.id).where("exercise_modifications.date >= ?", Date.today).order("exercise_modifications.date")
      @user = user
    else
      redirect_to login_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @data = {}
    @data[:tracked] = @user.tracked_values.joins(:available_value)
    @data[:tickets] = @user.tickets.where(single_use: false)
    @data[:exercises] = Exercise.joins(:exercise_modification).joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", @user.id).where("exercise_modifications.date >= ?", Date.today).order("exercise_modifications.date")
    @data[:pending_singles] = @user.tickets.where(single_use: true).where(paid: false)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end
  
  def admin_edit
    params[:access_level] = User.get_access_level_string(@user.access_level)
    @values = Hash.new
    AvailableValue.find_each do |value|
      if @user.tracked_values.where(available_value: value).count > 0
        @values[value] = true
      else
        @values[value] = false
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.access_level = User.al_registered

    respond_to do |format|
      if @user.save
        # Send welcome email
        UserMailer.welcome_email(@user).deliver_later

        format.html { redirect_to :root, notice: 'Registrace proběhla úspěšně.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Údaje úspěšně změněny.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def admin_update
    @user.access_level = User.parse_access_level(params[:user][:access_level])
    
    params[:user][:goals].each do |key, value|
      puts "#{AvailableValue.find(key).name}: #{value}"
      if @user.tracked_values.where("available_value_id = ?", key.to_i).count > 0
        if value.to_i == 1
          # keep tracked
        else
          # remove tracked
          @user.tracked_values.where("available_value_id = ?", key.to_i).destroy_all
        end
      else
        if value.to_i == 1
          # create tracked
          @user.tracked_values.create(available_value_id: key.to_i)
        else
          # do nothing
        end
      end
    end
    @user.save!
    
    redirect_to users_path
  end
  
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def self_edit?
    if(access_for_level?(User.al_admin))
      return true
    else
      set_user
      if(@user == current_user)
        return true
      else
        redirect_to :root, alert: 'Máte právo spravovat pouze své vlastní údaje'
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :note)
  end
end
