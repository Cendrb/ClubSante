class TicketsController < ApplicationController
  before_filter :authenticate_admin
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :mark_as_paid]
  after_action :null_out_pendings, only: [:create, :update]

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
    params[:time_restriction_months] = 6
    @ticket.user_id = params[:user_id]
  end

  # GET /tickets/1/edit
  def edit
    if @ticket.entries_remaining == -1
      params[:type] = "Časově omezená"
    else
      params[:type] = "Omezená vstupy"
    end

    params[:activate] = "nope"

    params[:time_restriction_months] = (@ticket.time_restriction/60/60/24/30)
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.single_use = false
    params.permit!
    if params[:activate]
      @ticket.activated_on = Date.today
    else
      @ticket.activated_on = params[:activated_on]
    end
    if params[:type] == "Časově omezená"
      @ticket.entries_remaining = -1

      # pokud omezena vstupy -> activerecord nastaví sám od sebe do modelu (form_for)
    end
    if params[:time_restriction_months]
      @ticket.time_restriction = (params[:time_restriction_months].to_i.months).to_i
      respond_to do |format|
        if @ticket.save
          format.html { redirect_to @ticket.user, notice: 'Permanentka vytvořena' }
          format.json { render :show, status: :created, location: @ticket }
        else
          format.html { render :new }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    else
      if !params[:time_restriction_months]
        @ticket.errors.add(:time_restriction_months, "musí být kladné číslo")
      end
      render :new
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    @ticket.update(ticket_params)
    params.permit!
    if params[:activate]
      @ticket.activated_on = Date.today
    else
      @ticket.activated_on = params[:activated_on]
    end
    if params[:type] == "Časově omezená"
      @ticket.entries_remaining = -1

      # pokud omezena vstupy -> activerecord nastaví sám od sebe do modelu (form_for)
    end
    if params[:time_restriction_months]
      @ticket.time_restriction = (params[:time_restriction_months].to_i.months).to_i
      respond_to do |format|
        if @ticket.save
          format.html { redirect_to tickets_path, notice: 'Permanentka upravena' }
          format.json { render :show, status: :created, location: @ticket }
        else
          format.html { render :new }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    else
      if !params[:time_restriction_months]
        @ticket.errors.add(:time_restriction_months, "musí být kladné číslo")
      end
      render :new
    end
  end

  def mark_as_paid
    @ticket.paid = true
    @ticket.save

    @data = {pending_singles: current_user.tickets.where(single_use: true).where(paid: false)}

    render "tickets/user_show/replace_pending_singles"
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to @ticket.user, notice: "Permanentka na #{get_ticket_therapies_string @ticket} úspěšně odstraněna" }
      format.json { head :no_content }
    end
  end

  private
  def null_out_pendings
    if @ticket.entries_remaining > 0
      @ticket.user.tickets.where(single_use: true).where(paid: false).find_each do |pending|
        if @ticket.entries_remaining > 0 && (@ticket.activated_on <= (pending.activated_on + pending.time_restriction)) && ((@ticket.activated_on + @ticket.time_restriction) >= pending.activated_on)
          @ticket.entries_remaining -= 1
          pending.paid = true
          pending.save!
        end
      end
    end
    @ticket.save!
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(:entries_remaining, :user_id, :time_restriction, :paid, :activated_on, :therapy_category_id)
  end
end
