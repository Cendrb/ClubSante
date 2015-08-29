class CalendarsController < ApplicationController
  before_filter :authenticate_admin, only: [:show]
  before_filter :authenticate_registered, only: [:show_final, :summary]
  
  def show
    @calendar = Calendar.find(params[:id])
  end
  
  def show_final
    @calendar = Calendar.find(params[:id])
    if params[:target_date]
      @date = Date.parse(params[:target_date])
    else
      @date = Date.today
    end
  end
  
  def summary
    @data = {}
    @data[:tickets] = current_user.tickets.where(single_use: false)
  end
end
