class TherapiesController < ApplicationController
  before_filter :authenticate_admin
  before_action :set_therapy, only: [:show, :edit, :update, :destroy]

  # GET /therapies
  # GET /therapies.json
  def index
    @therapies = Therapy.all
  end

  # GET /therapies/1
  # GET /therapies/1.json
  def show
    
  end

  # GET /therapies/new
  def new
    @therapy = Therapy.new
  end

  # GET /therapies/1/edit
  def edit
  end

  # POST /therapies
  # POST /therapies.json
  def create
    @therapy = Therapy.new(therapy_params)
    if(@therapy.can_single_use)
      category = TherapyCategory.new(name: @therapy.name)
      category.therapies << @therapy
      category.save!
    end

    respond_to do |format|
      if @therapy.save
        format.html { redirect_to @therapy }
        format.json { render :show, status: :created, location: @therapy }
      else
        format.html { render :new }
        format.json { render json: @therapy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /therapies/1
  # PATCH/PUT /therapies/1.json
  def update
    respond_to do |format|
      if @therapy.update(therapy_params)
        format.html { redirect_to @therapy }
        format.json { render :show, status: :ok, location: @therapy }
      else
        format.html { render :edit }
        format.json { render json: @therapy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /therapies/1
  # DELETE /therapies/1.json
  def destroy
    @therapy.destroy
    respond_to do |format|
      format.html { redirect_to therapies_url, notice: 'Therapy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_therapy
      @therapy = Therapy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def therapy_params
      params.require(:therapy).permit(:name, :capacity, :duration_in_minutes, :can_single_use)
    end
end
