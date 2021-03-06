class RecordsController < ApplicationController
  before_filter :authenticate_admin
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    @data = {}
    if (params[:user_id])
      @records = Record.joins(:tracked_value).where("tracked_values.user_id = ?", params[:user_id]).order(:date)
      @data[:user] = User.find(params[:user_id])
    else
      @records = Record.all.order(:date)
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    params[:date] = Date.today
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = User.first
    end
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    params[:records].each do |key, value|
      t_value = TrackedValue.find(key)
      Record.create(tracked_value: t_value, value: value, date: params[:date].map { |k, v| v }.join("-").to_date)
    end
    redirect_to records_path and return
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_record
    @record = Record.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def record_params
    params.require(:record).permit(:tracked_value_id, :value, :date)
  end
end
