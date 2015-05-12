class CalendarsController < ApplicationController
  def show
    @calendar = Calendar.find(params[:id])
    if params[:target_date]
      @date = Date.parse(params[:target_date])
    else
      @date = Date.today
    end
  end
  
  def summary
    
  end
end
