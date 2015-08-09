class TherapyCategoriesController < ApplicationController
  before_filter :authenticate_admin
  before_action :set_therapy_category, only: [:show, :edit, :update, :destroy]

  # GET /therapy_categories
  # GET /therapy_categories.json
  def index
    @therapy_categories = TherapyCategory.all
  end

  # GET /therapy_categories/1
  # GET /therapy_categories/1.json
  def show
  end

  # GET /therapy_categories/new
  def new
    @therapy_category = TherapyCategory.new
    @therapies = Hash.new
    Therapy.find_each do |therapy|
      @therapies[therapy] = false
    end
  end

  # GET /therapy_categories/1/edit
  def edit
    @therapies = Hash.new
    Therapy.find_each do |therapy|
      if @therapy_category.therapies.where(id: therapy.id).count > 0
        @therapies[therapy] = true
      else
        @therapies[therapy] = false
      end
    end
  end

  # POST /therapy_categories
  # POST /therapy_categories.json
  def create
    @therapy_category = TherapyCategory.new(therapy_category_params)
    
    params[:therapy_category][:therapies].each do |key, value|
      if(value.to_i == 1)
        @therapy_category.therapies << Therapy.find(key)
      end
    end

    respond_to do |format|
      if @therapy_category.save
        format.html { redirect_to therapy_categories_path }
        format.json { render :show, status: :created, location: @therapy_category }
      else
        format.html { render :new }
        format.json { render json: @therapy_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /therapy_categories/1
  # PATCH/PUT /therapy_categories/1.json
  def update
    params[:therapy_category][:therapies].each do |key, value|
      if(value.to_i == 1)
        if(@therapy_category.therapies.where(id: key).count == 0) 
          @therapy_category.therapies << Therapy.find(key)
        end
      else
        if(@therapy_category.therapies.where(id: key).count > 0) 
          @therapy_category.therapies.delete(@therapy_category.therapies.where(id: key).first)
          @therapy_category.save
        end
      end
    end
    
    respond_to do |format|
      if @therapy_category.update(therapy_category_params)
        format.html { redirect_to therapy_categories_path }
        format.json { render :show, status: :ok, location: @therapy_category }
      else
        format.html { render :edit }
        format.json { render json: @therapy_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /therapy_categories/1
  # DELETE /therapy_categories/1.json
  def destroy
    @therapy_category.destroy
    respond_to do |format|
      format.html { redirect_to therapy_categories_url, notice: 'Therapy category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_therapy_category
      @therapy_category = TherapyCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def therapy_category_params
      params.require(:therapy_category).permit(:name)
    end
end
