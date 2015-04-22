class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
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

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
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

  def signup_for_new
    date = Date.parse(params[:date])
    @exercise_template = ExerciseTemplate.find(params[:exercise_template_id])
    @beginning_offset = params[:beginning_offset].to_i

    ticket = ticket_selector(@exercise_template.timetable_template.calendar.therapy, date)
    date = date.to_datetime + @exercise_template.beginning.seconds_since_midnight.seconds
    
    if ticket
      if ticket.entries_available?(date, @exercise_template.timetable_template.calendar.therapy)
        @exercise = Exercise.create(date: date, timetable: @exercise_template.timetable_template.calendar.timetable)
        ticket.register_entry(@exercise)
        render "signup_create_exercise.js.erb"
      else
        render plain: "allahu akbar"
      end
    end
  end
  
  def signup_for_existing
    @exercise = Exercise.find(params[:exercise_id])
    @beginning_offset = params[:beginning_offset].to_i
    
    ticket = ticket_selector(@exercise.timetable.calendar.therapy, @exercise.date)
    
    if ticket
      if ticket.entries_available?(@exercise.date, @exercise.timetable.calendar.therapy)
        ticket.register_entry(@exercise)
        render "signup_edit_existing_exercise.js.erb"
      else
        render nothing: true
      end
    end
  end

  private
  
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
          @tickets = current_user.tickets
          @target_therapy = therapy
          @target_date = date
          render "ticket_selector_form.js.erb", status: 200 and return
        end
      else
        # any usable tickets were not found
        render "any_tickets.js.erb", status: 401 and return
      end
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

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
