class TimetableModificationsController < ApplicationController
  before_action :set_timetable_modification, only: [:show, :edit, :update, :destroy]

  # GET /timetable_modifications
  # GET /timetable_modifications.json
  def index
    @timetable_modifications = TimetableModification.all
  end

  # GET /timetable_modifications/new
  def new
    @timetable_modification = TimetableModification.new
  end

  # GET /timetable_modifications/1/edit
  def edit
    if params[:target_date]
      @date = Date.parse(params[:target_date])
    else
      @date = Date.today
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /timetable_modifications
  # POST /timetable_modifications.json
  def create
    @timetable_modification = TimetableModification.new(timetable_modification_params)

    respond_to do |format|
      if @timetable_modification.save
        format.html { redirect_to @timetable_modification, notice: 'Timetable modification was successfully created.' }
        format.json { render :show, status: :created, location: @timetable_modification }
      else
        format.html { render :new }
        format.json { render json: @timetable_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timetable_modifications/1
  # PATCH/PUT /timetable_modifications/1.json
  def update
    respond_to do |format|
      if @timetable_modification.update(timetable_modification_params)
        format.html { redirect_to @timetable_modification, notice: 'Timetable modification was successfully updated.' }
        format.json { render :show, status: :ok, location: @timetable_modification }
      else
        format.html { render :edit }
        format.json { render json: @timetable_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timetable_modifications/1
  # DELETE /timetable_modifications/1.json
  def destroy
    @timetable_modification.destroy
    respond_to do |format|
      format.html { redirect_to timetable_modifications_url, notice: 'Timetable modification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timetable_modification
      @timetable_modification = TimetableModification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timetable_modification_params
      params.require(:timetable_modification).permit(:calendar_id)
    end
end
