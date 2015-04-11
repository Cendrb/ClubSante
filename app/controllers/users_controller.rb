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

  def signup
    date = Date.parse(params[:date])
    if params[:exercise_template_id]
      exercise_template = ExerciseTemplate.find(params[:exercise_template_id])
    else
      exercise = Exercise.find(params[:exercise_id])
    end

    if params[:ticket_id]
      # ticket already selected
      ticket_signup(Ticket.find(params[:ticket_id]), exercise_template, date)
    else
      tickets_available = current_user.tickets_with_entries_avalaible(exercise_template.therapy, date)

      if tickets_available.count > 0
        if tickets_available.count == 1
          # just one - no need for an additional form
          ticket_signup(tickets_available.first, exercise_template, date)
        else
          # more than one - show js form
        end
      else
        # any usable tickets were not found
      end
    end
  end

  private

  def ticket_signup(ticket, template, date)
    @exercise = Exercise.create(date: date, timetable: template.timetable_template.calendar.timetable)
    @exercise.signup_with(ticket)
    render "signup.js.erb"
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
