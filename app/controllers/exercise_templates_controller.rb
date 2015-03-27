class ExerciseTemplatesController < ApplicationController
  before_action :set_exercise_template, only: [:show, :edit, :update, :destroy]

  # GET /exercise_templates
  # GET /exercise_templates.json
  def index
    @exercise_templates = ExerciseTemplate.all
  end

  # GET /exercise_templates/1
  # GET /exercise_templates/1.json
  def show
  end

  # GET /exercise_templates/new
  def new
    @exercise_template = ExerciseTemplate.new
  end

  # GET /exercise_templates/1/edit
  def edit
  end

  # POST /exercise_templates
  # POST /exercise_templates.json
  def create
    @exercise_template = ExerciseTemplate.new(exercise_template_params)

    respond_to do |format|
      if @exercise_template.save
        format.html { redirect_to @exercise_template, notice: 'Exercise template was successfully created.' }
        format.json { render :show, status: :created, location: @exercise_template }
        format.js
        format.whoa { render plain: 'success', status: :ok }
      else
        format.html { render :new }
        format.json { render json: @exercise_template.errors, status: :unprocessable_entity }
        format.whoa { render plain: 'fail', status: :unprocessable_entity }
        format.js { render plain: 'fail', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_templates/1
  # PATCH/PUT /exercise_templates/1.json
  def update
    respond_to do |format|
      if @exercise_template.update(exercise_template_params)
        format.html { redirect_to @exercise_template, notice: 'Exercise template was successfully updated.' }
        format.json { render :show, status: :ok, location: @exercise_template }
        format.whoa { render plain: 'success', status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @exercise_template.errors, status: :unprocessable_entity }
        format.whoa { render plain: 'fail', status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_templates/1
  # DELETE /exercise_templates/1.json
  def destroy
    @exercise_template.destroy
    respond_to do |format|
      format.html { redirect_to exercise_templates_url, notice: 'Exercise template was successfully destroyed.' }
      format.json { head :no_content }
      format.whoa { render plain: 'success', status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_template
      @exercise_template = ExerciseTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_template_params
      params.require(:exercise_template).permit(:beginning, :weekday_template_id)
    end
end
