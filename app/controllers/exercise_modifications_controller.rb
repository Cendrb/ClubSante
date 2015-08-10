class ExerciseModificationsController < ApplicationController
  before_filter :authenticate_admin
  before_action :set_exercise_modification, only: [:show, :edit, :update, :destroy]

  # GET /exercise_modifications
  # GET /exercise_modifications.json
  def index
    @exercise_modifications = ExerciseModification.all
  end

  # GET /exercise_modifications/1
  # GET /exercise_modifications/1.json
  def show
  end

  # GET /exercise_modifications/new
  def new
    @exercise_modification = ExerciseModification.new
    calendar = Calendar.find(params[:calendar_id])
    @exercise_modification.timetable_modification = calendar.timetable_modification
    if(params[:exercise_template_id])
      exercise_template = ExerciseTemplate.find(params[:exercise_template_id])
       @exercise_modification.exercise_template = exercise_template
       @exercise_modification.load_default_values_from(exercise_template)
       @exercise_modification.date = params[:date].to_datetime + exercise_template.beginning.seconds_since_midnight.seconds
    else
      @exercise_modification.coach = Coach.get_nobody
      @exercise_modification.price = ExerciseTemplate.get_hide_string
      @exercise_modification.date = params[:datetime].to_datetime
    end
    respond_to do |format|
      format.js { render "display_exercise_modification_dialog" }
      format.html
    end
  end

  # GET /exercise_modifications/1/edit
  def edit
    respond_to do |format|
      format.js { render "display_exercise_modification_dialog" }
      format.html
    end
  end

  # POST /exercise_modifications.js
  def create
    @exercise_modification = ExerciseModification.new(exercise_modification_params)

    respond_to do |format|
      if @exercise_modification.save!
        format.js { render "timetable_modifications/reload_timetable_modification", locals: {timetable_modification: @exercise_modification.timetable_modification, beginning_date: @exercise_modification.date} }
      else
        format.js { render plain: @exercise_modification.errors.full_messages, status: :error }
      end
    end
  end

  # PATCH/PUT /exercise_modifications/1
  # PATCH/PUT /exercise_modifications/1.json
  def update
    respond_to do |format|
      if @exercise_modification.update(exercise_modification_params)
        format.js { render "timetable_modifications/reload_timetable_modification", locals: {timetable_modification: @exercise_modification.timetable_modification, beginning_date: @exercise_modification.date} }
      else
        format.js { render plain: @exercise_modification.errors.full_messages, status: :error }
      end
    end
  end

  # DELETE /exercise_modifications/1
  # DELETE /exercise_modifications/1.json
  def destroy
    @exercise_modification.destroy
    respond_to do |format|
      format.html { redirect_to exercise_modifications_url, notice: 'Exercise modification was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render "timetable_modifications/reload_timetable_modification", locals: {timetable_modification: @exercise_modification.timetable_modification, beginning_date: @exercise_modification.date} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_modification
      @exercise_modification = ExerciseModification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_modification_params
      params.require(:exercise_modification).permit(:exercise_template_id, :date, :coach_id, :price, :note, :timetable_modification_id, :removal)
    end
end
