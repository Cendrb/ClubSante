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
  
  def multi_edit
    @exercise_template = ExerciseTemplate.new
    params[:affected_exercise_templates] = params[:affected_exercise_templates].to_a
    if(params[:affected_exercise_templates].length == 1)
      template = ExerciseTemplate.find(params[:affected_exercise_templates].first)
      params[:price] = template.price
      params[:coach_id] = template.coach_id
    else
      params[:affected_exercise_templates].each do |id|
        template = ExerciseTemplate.find(id)
        if(params[:price] == nil)
          if(template.price)
            params[:price] = template.price
          else
            params[:price] = "< ponechat >"
          end
        else
          if(params[:price] != template.price)
            params[:price] = "< ponechat >"
          end
        end
        
        puts "PENIS: " + template.coach_id.to_s
        if(params[:coach_id] == nil)
          if(template.coach_id)
            params[:coach_id] = template.coach_id
          else
            params[:coach_id] = 0
          end
        else
          if(params[:coach_id] != template.coach_id)
            params[:coach_id] = 0
          end
        end
      end
    end
  end

  # POST /exercise_templates
  # POST /exercise_templates.json
  def create
    @exercise_template = ExerciseTemplate.new(exercise_template_params)
    @exercise_template.price = "Nezobrazovat"
    @exercise_template.coach = Coach.get_nobody

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
        format.js { render json: @exercise_template.errors, status: :unprocessable_entity }
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
        format.whoa { render plain: @exercise_template.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def multi_update
    params[:affected_exercise_templates] = params[:affected_exercise_templates].split(",")
    @exercise_templates = []
    params[:affected_exercise_templates].each do |id|
      template = ExerciseTemplate.find(id)
      if(params[:price] != "< ponechat >")
        template.price = params[:price]
      end
      if(params[:coach_id] != "")
        template.coach_id = params[:coach_id]
      end
      template.save!
      @exercise_templates.push(template)
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
      params.require(:exercise_template).permit(:beginning, :weekday, :timetable_template_id, :coach_id, :price)
    end
end
