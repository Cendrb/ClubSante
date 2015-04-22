class CalendarsController < ApplicationController
  def show
    @calendar = Calendar.find(params[:id])
    @registered = @calendar.timetable.exercises#.between(1.days.ago, 5.days.from_now)
    @templates = @calendar.timetable_template.exercise_templates#.where("weekday IN (:weekdays)", weekdays: weekdays)

    @first_hour = Calendar.min_hour_for(@registered, @templates)
    @last_hour = Calendar.max_hour_for(@registered, @templates)
    
    @monday_date = Date.today - (Date.today.wday - 1).days
    
    @beginning_offset = @first_hour * 60 * Calendar.pixels_per_minute
    
    # TERRIBLE CODE
    #@templates = @templates.to_a
    #@templates.delete_if do |template|
    #  @registered.each do |registered|
    #    return (registered.date)..(registered.date + @calendar.therapy.duration_in_minutes.minutes).overlaps?((template.beginning)..(template.beginning + @calendar.therapy.duration_in_minutes.minutes))
    #  end
    #end
  end
end
