class ExerciseRegisterController < ApplicationController
  before_filter :authenticate_registered
  before_filter :authenticate_admin, only: :admin_edit

  def subscribe_for_template
    date = Date.parse(params[:date]).to_datetime.in_time_zone - Time.now.in_time_zone.utc_offset - (Time.now.in_time_zone.dst? ? 3600 : 0 )
    @exercise_template = ExerciseTemplate.find(params[:exercise_template_id])
    if !@exercise_template.exercise_modification
      @beginning_offset = params[:beginning_offset].to_i
      puts "Motorku" + @beginning_offset.to_s
      date = date + @exercise_template.beginning.in_time_zone.seconds_since_midnight.seconds

      if validate_date_signup(date)
        ticket = ticket_selector(@exercise_template.timetable_template.calendar.therapy, date)

        if ticket
          if ticket.entries_available?(date, @exercise_template.timetable_template.calendar.therapy)
            exercise_modification = ExerciseModification.new(date: date, timetable_modification: @exercise_template.timetable_template.calendar.timetable_modification, exercise_template: @exercise_template, removal: false)
            exercise_modification.save!
            @exercise = Exercise.create(exercise_modification: exercise_modification, timetable: @exercise_template.timetable_template.calendar.timetable)
            ticket.register_entry(@exercise)
            render "subscribe_replace_template_or_modification_with_new.js.erb"
          else
            render plain: "allahu akbar"
          end
        end
      end
    else
      render_alert "Not a template"
    end
  end

  def subscribe_for_modification
    @exercise_modification = ExerciseModification.find(params[:exercise_modification_id])
    @beginning_offset = params[:beginning_offset].to_i

    if validate_date_signup(@exercise_modification.date) && validate_modification_signup(@exercise_modification)
      ticket = ticket_selector(@exercise_modification.timetable_modification.calendar.therapy, @exercise_modification.date)

      if ticket
        if ticket.entries_available?(@exercise_modification.date, @exercise_modification.timetable_modification.calendar.therapy)
          @exercise = Exercise.create(exercise_modification: @exercise_modification, timetable: @exercise_modification.timetable_modification.calendar.timetable)
          ticket.register_entry(@exercise)
          render "subscribe_replace_template_or_modification_with_new.js.erb"
        else
          render plain: "allahu akbar"
        end
      end
    end
  end

  def subscribe_for_existing
    @exercise = Exercise.find(params[:exercise_id])
    @beginning_offset = params[:beginning_offset].to_i

    if validate_signup(@exercise, current_user)
      ticket = ticket_selector(@exercise.timetable.calendar.therapy, @exercise.date)

      if ticket
        if ticket.entries_available?(@exercise.date, @exercise.timetable.calendar.therapy)
          ticket.register_entry(@exercise)
          render "subscribe_edit_existing_exercise.js.erb"
        else
          render nothing: true
        end
      end
    end
  end

  def unsubscribe_from
    @exercise = Exercise.find(params[:exercise_id])
    @beginning_offset = params[:beginning_offset].to_i
    entry = Entry.joins(:ticket).where("tickets.user_id = ?", current_user.id).where("exercise_id = ?", @exercise.id).first
    exercise_modification = @exercise.exercise_modification
    @date = exercise_modification.date

    if (@date < Time.now.utc)
      render_alert("Není možné se odhlásit ze cvičení z minulosti")
    else
      entry_void = @date - Time.now < Ticket.unsubscribe_time_limit
      if (entry_void && !params[:force])
        render 'prompt_ticket_entry_void'
      else
        ticket = entry.ticket
        ticket.unregister_entry(@exercise, entry, entry_void)

        if entry.exercise.destroyed?
          if entry.exercise.exercise_modification.destroyed?
            @exercise_template = entry.exercise.exercise_modification.exercise_template
            mode = :template
          else
            @exercise_modification = entry.exercise.exercise_modification
            mode = :modification
          end
        else
          @exercise = entry.exercise
          mode = :exercise
        end

        if (params[:source] == "calendar_view")
          render "unsubscribe_from_calendar_view", locals: {mode: mode}
        else
          render "unsubscribe_from_user_summary_list", locals: {tickets: current_user.tickets}
        end
      end
    end
  end

  def admin_edit

  end

  private

  def render_alert(message)
    render "alert", locals: {message: message}, status: 401
  end

  def ticket_selector(therapy, date)
    if params[:ticket_id]
      # ticket already selected
      return Ticket.find(params[:ticket_id])
    else
      tickets_available = Ticket.for_therapy(current_user.tickets.with_available_entries(date), therapy)

      if tickets_available.count > 0
        if tickets_available.count == 1
          # just one - no need for an additional form
          return tickets_available.first
        else
          # more than one - show js form
          @tickets = Ticket.for_therapy(current_user.tickets.where(single_use: false), therapy)
          @target_therapy = therapy
          @target_date = date
          render "ticket_selector_form.js.erb", status: 200 and return
        end
      else
        # any usable tickets were not found
        # try creating single use one
        single_use = Ticket.create_single_use(current_user, therapy)
        if (single_use)
          return single_use
        else
          # you cannot create single use ticket from this therapy (need special category)
          render_alert "Pro tuto terapii (#{therapy.name.downcase}) musíte mít předem koupenou permanentku"
          return
        end
      end
    end
  end

  def validate_signup(exercise, user)
    result = User.validate_exercise_signup(exercise, user)
    if result != true
      render_alert(result)
      return false
    end
    return true
  end

  def validate_date_signup(date)
    result = User.validate_date_signup(date)
    if result != true
      render_alert(result)
      return false
    end
    return true
  end

  def validate_modification_signup(modification)
    if (modification.removal)
      render_alert("Tato hodina byla zrušena")
      return false
    end
    return true
  end
end