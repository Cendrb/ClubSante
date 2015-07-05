class UsersController < ApplicationController
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
    if user
      @tickets = user.tickets
      @exercises = Exercise.joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", user.id).where("exercises.date >= ?", Date.today).order(:date)
    else
      redirect_to login_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
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

    respond_to do |format|
      if @user.save
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
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
    
    redirect_to @user
  end

  def subscribe_for_new
    date = Date.parse(params[:date])
    @exercise_template = ExerciseTemplate.find(params[:exercise_template_id])
    @beginning_offset = params[:beginning_offset].to_i
    
    if validate_date_signup(date)
      ticket = ticket_selector(@exercise_template.timetable_template.calendar.therapy, date)
      date = date.to_datetime + @exercise_template.beginning.seconds_since_midnight.seconds
      
      if ticket
        if ticket.entries_available?(date, @exercise_template.timetable_template.calendar.therapy)
          @exercise = Exercise.create(date: date, timetable: @exercise_template.timetable_template.calendar.timetable)
          ticket.register_entry(@exercise)
          render "subscribe_create_exercise.js.erb"
        else
          render plain: "allahu akbar"
        end
      end
    end
  end
  
  def subscribe_for_existing
    @exercise = Exercise.find(params[:exercise_id])
    @beginning_offset = params[:beginning_offset].to_i
    
    if validate_signup(@exercise, current_user)
      ticket = ticket_selector(@exercise.timetable.calendar.therapy, @exercise.date)
      
      if ticket
        if ticket.entries_available?(@exercise.date, @exercise.timetable.calendar.therapy)
          ticket.register_entry(@exercise)
          render "subscribe_edit_existing_exercise.js.erb"
        else
          render nothing: true
        end
      end
    end
  end
  
  def unsubscribe_from
    @exercise = Exercise.find(params[:exercise_id])
    @beginning_offset = params[:beginning_offset].to_i
    entry = Entry.joins(:ticket).where("tickets.user_id = ?", current_user.id).where("exercise_id = ?", @exercise.id).first
    ticket = entry.ticket
    ticket.unregister_entry(@exercise, entry)
    
    if(params[:source] == "calendar_view")
      render "users/unsubscribe_from_calendar_view"
    else
      render "users/unsubscribe_from_user_summary_list", locals: { tickets: current_user.tickets }
    end
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
  
  def render_alert(message)
    render "alert", locals: { message: message }, status: 401
  end
  
  def ticket_selector(therapy, date)
    if params[:ticket_id]
      # ticket already selected
      return Ticket.find(params[:ticket_id])
    else
      tickets_available = current_user.tickets.with_available_entries(therapy, date)
      
      if tickets_available.count > 0
        if tickets_available.count == 1
          # just one - no need for an additional form
          return tickets_available.first
        else
          # more than one - show js form
          @tickets = current_user.tickets.where(therapy: therapy)
          @target_therapy = therapy
          @target_date = date
          render "ticket_selector_form.js.erb", status: 200 and return
        end
      else
        # any usable tickets were not found
        render_alert "Nebyly nalezeny žádné platné permanentky"
        return
      end
    end
  end
  
  def validate_signup(exercise, user)
    result = User.validate_exercise_signup(exercise, user)
    if result != true
      render_alert(result)
      return false
    end
    return true
  end
  
  def validate_date_signup(date)
    result = User.validate_date_signup(date)
    if result != true
      render_alert(result)
      return false
    end
    return true
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
