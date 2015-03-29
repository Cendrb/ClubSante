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
    @templates = @calendar.timetable_template.exercise_templates.where("weekday IN (:weekdays)", weekdays: weekdays).to_a
    @templates.delete_if do |template|
      @registered.each do |registered|
        return (registered.date)..(registered.date + @calendar.therapy.duration_in_minutes.minutes).overlaps?((template.beginning)..(template.beginning + @calendar.therapy.duration_in_minutes.minutes))
      end
    end
  end
end
