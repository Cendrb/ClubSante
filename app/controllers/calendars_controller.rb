class CalendarsController < ApplicationController
  def show
    @calendar = Calendar.find(params[:id])
    @registered = @calendar.timetable.exercises.between(Date.today, 5.days.from_now)
    @registered.each do |reg|
      puts reg
    end
    puts 'allahu'
    weekdays = @registered.pluck(:date).map(&:wday)
    weekdays.each do |day|
      puts day
    end
    puts 'akbar'
    @templates = @calendar.timetable_template.exercise_templates#.where("weekday IN (:weekdays)", weekdays: weekdays)
    
    @templates.each do |template|
      puts template
    end
    
    # najde
    if(@registered.minimum("EXTRACT(HOUR FROM date)").nil?)
      registered_min_hour = 69
    else
      registered_min_hour = @registered.minimum("EXTRACT(HOUR FROM date)")
    end
    
    if(@registered.maximum("EXTRACT(HOUR FROM date)").nil?)
      registered_max_hour = -69
    else
      registered_max_hour = @registered.minimum("EXTRACT(HOUR FROM date)")
    end
    
    @first_hour = [registered_min_hour, @templates.minimum(:beginning).hour].min
    @last_hour = [registered_max_hour, @templates.maximum(:beginning).hour].max + 1
    
    # TERRIBLE CODE
    #@templates = @templates.to_a
    #@templates.delete_if do |template|
    #  @registered.each do |registered|
    #    return (registered.date)..(registered.date + @calendar.therapy.duration_in_minutes.minutes).overlaps?((template.beginning)..(template.beginning + @calendar.therapy.duration_in_minutes.minutes))
    #  end
    #end
    
    @pixels_per_minute = 1
  end
end
