class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.all
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    params[:type] = "Časově omezená"
    params[:activate] = true
    params[:time_restriction_days] = 0
    params[:time_restriction_months] = 6
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    params.permit!
    @ticket = Ticket.new(params[:ticket])
    if params[:activate]
      @ticket.activated_on = Date.today
    else
      @ticket.activated_on = nil
    end
    if params[:type] == "Časově omezená"
      @ticket.entries_remaining = -1
      
      # pokud omezena vstupy -> activerecord nastaví sám od sebe do modelu (form_for)
    end
    if params[:time_restriction_days] && params[:time_restriction_months]
      @ticket.time_restriction = (params[:time_restriction_days].to_i.days + params[:time_restriction_months].to_i.months).to_i
      respond_to do |format|
        if @ticket.save
          format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
          format.json { render :show, status: :created, location: @ticket }
        else
          format.html { render :new }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    else
      if !params[:time_restriction_days]
        @ticket.errors.add(:time_restriction_days, "musí být kladné číslo")
      end
      if !params[:time_restriction_months]
        @ticket.errors.add(:time_restriction_months, "musí být kladné číslo")
      end
      render :new
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:entries_remaining, :user_id, :time_restriction, :paid, :activated_on, :therapy_id)
    end
end
