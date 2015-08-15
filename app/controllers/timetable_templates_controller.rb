class TimetableTemplatesController < ApplicationController
  before_filter :authenticate_admin
  before_action :set_timetable_template, only: [:edit, :update, :destroy]

  # GET /timetable_templates
  # GET /timetable_templates.json
  def index
    @timetable_templates = TimetableTemplate.all
  end
  
  # GET /timetable_templates/new
  def new
    @timetable_template = TimetableTemplate.create(beginning: Date.today, calendar: Calendar.find(params[:calendar_id]))
    @timetable_template.save!
  end

  # GET /timetable_templates/1/edit
  def edit
  end

  # POST /timetable_templates
  # POST /timetable_templates.json
  def create
    @timetable_template = TimetableTemplate.new(timetable_template_params)

    respond_to do |format|
      if @timetable_template.save
        format.html { redirect_to @timetable_template, notice: 'Timetable template was successfully created.' }
        format.json { render :show, status: :created, location: @timetable_template }
      else
        format.html { render :new }
        format.json { render json: @timetable_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timetable_templates/1
  # PATCH/PUT /timetable_templates/1.json
  def update
    respond_to do |format|
      if @timetable_template.update(timetable_template_params)
        format.html { redirect_to @timetable_template, notice: 'Timetable template was successfully updated.' }
        format.json { render :show, status: :ok, location: @timetable_template }
      else
        format.html { render :edit }
        format.json { render json: @timetable_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timetable_templates/1
  # DELETE /timetable_templates/1.json
  def destroy
    @timetable_template.destroy
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timetable_template
      @timetable_template = TimetableTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timetable_template_params
      params[:timetable_template].permit(:calendar_id, :beginning)
    end
end
