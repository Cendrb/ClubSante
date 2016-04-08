require 'securerandom'

class ExerciseRegisterController < ApplicationController
  before_filter :authenticate_registered
  before_filter :authenticate_admin, only: :admin_edit

  def subscribe
    get_mode(params[:mode])
    if params[:user] && current_user.access_for_level?(User.al_admin)
      @data[:user] = User.find(params[:user])
    else
      if params[:user_first_name] && params[:user_last_name] && current_user.access_for_level?(User.al_admin)
        if params[:email] && params[:email] != ""
          email = params[:email]
        else
          email = "#{params[:user_first_name]}.#{params[:user_last_name]}@neplatny.mail"
        end
        @data[:user] = User.create(first_name: params[:user_first_name], last_name: params[:user_last_name], email: email, password: SecureRandom.hex, access_level: User.al_registered)
      else
        @data[:user] = current_user
      end
    end
    @data[:beginning_offset] = params[:beginning_offset].to_i
    case @data[:mode]
      when :template
        subscribe_for_template
      when :modification
        subscribe_for_modification
      when :exercise
        subscribe_for_exercise
    end
  end

  def subscribe_for_template
    if true # todo: add check for existing modification (on current date)
      if validate_date_signup(@data[:date]) # not in past/ renders error
        ticket = ticket_selector(@data[:object].timetable_template.calendar.therapy, @data[:date]) # check for available tickets if more/ render ticket selection form

        if ticket # if form rendered then do not register yet
          if current_user.access_for_level?(User.al_admin) && params[:require_payment] == "Ne" # allow admin free registration
            if ticket.single_use # if single_use/ mark as paid
              ticket.paid = true
              ticket.save!
            else
              if ticket.entries_remaining > 0 # if time based/ nothing else/ add one entry
                ticket.entries_remaining += 1
              end
            end
          end

          if ticket.entries_available?(@data[:date], @data[:object].timetable_template.calendar.therapy) # just to make sure that selected ticket has entries available
            exercise_modification = ExerciseModification.new(date: @data[:date], timetable_modification: @data[:object].timetable_template.calendar.timetable_modification, exercise_template: @data[:object], removal: false)
            exercise_modification.save!
            @data[:exercise_result] = Exercise.create(exercise_modification: exercise_modification, timetable: @data[:object].timetable_template.calendar.timetable)
            ticket.register_entry(@data[:exercise_result])
            render "subscribe_replace_template_or_modification_with_new.js.erb"
          else
            render plain: "This should never happen"
          end
        end
      end
    else
      render_alert "Not a template"
    end
  end

  def subscribe_for_modification
    if validate_date_signup(@data[:object].date) && validate_modification_signup(@data[:object]) # not in past AND not marked as "removed"/ renders error
      ticket = ticket_selector(@data[:object].timetable_modification.calendar.therapy, @data[:object].date) # check for available tickets if more/ render ticket selection form

      if ticket # if form rendered then do not register yet
        if ticket.entries_available?(@data[:object].date, @data[:object].timetable_modification.calendar.therapy) # just to make sure that selected ticket has entries available
          @data[:exercise_result] = Exercise.create(exercise_modification: @data[:object], timetable: @data[:object].timetable_modification.calendar.timetable)
          ticket.register_entry(@data[:exercise_result])
          render "subscribe_replace_template_or_modification_with_new.js.erb"
        else
          render plain: "This should never happen"
        end
      end
    end
  end

  def subscribe_for_exercise
    if validate_signup(@data[:object], @data[:user]) # validate date, capacity, multiple rezervations/ renders error
      ticket = ticket_selector(@data[:object].timetable.calendar.therapy, @data[:object].exercise_modification.date) # check for available tickets if more/ render ticket selection form

      if ticket # if form rendered then do not register yet
        if ticket.entries_available?(@data[:object].exercise_modification.date, @data[:object].timetable.calendar.therapy) # just to make sure that selected ticket has entries available
          ticket.register_entry(@data[:object])
          render "subscribe_update_existing.js.erb"
        else
          render plain: "This should never happen"
        end
      end
    end
  end

  def unsubscribe_from
    @data = {}
    @data[:exercise] = Exercise.find(params[:id])
    @data[:beginning_offset] = params[:beginning_offset].to_i
    if params[:user] && current_user.access_for_level?(User.al_admin)
      @data[:user] = User.find(params[:user])
    else
      @data[:user] = current_user
    end
    entry = Entry.joins(:ticket).where("tickets.user_id = ?", @data[:user].id).where("exercise_id = ?", @data[:exercise].id).first
    exercise_modification = @data[:exercise].exercise_modification
    date = exercise_modification.date

    if (date < Time.now.utc)
      render_alert("Není možné se odhlásit ze cvičení z minulosti")
    else
      entry_void = date - Time.now < Ticket.unsubscribe_time_limit
      if (entry_void && !params[:force])
        render 'prompt_ticket_entry_void'
      else
        ticket = entry.ticket
        ticket.unregister_entry(@data[:exercise], entry, entry_void)

        if entry.exercise.destroyed?
          if entry.exercise.exercise_modification.destroyed?
            @data[:result] = entry.exercise.exercise_modification.exercise_template
            @data[:date] = date
            mode = :template
          else
            @data[:result] = entry.exercise.exercise_modification
            mode = :modification
          end
        else
          @data[:result] = entry.exercise
          mode = :exercise
        end

        if (params[:source] == "calendar_view")
          render "unsubscribe_from_calendar_view", locals: {mode: mode}
        else
          @data[:exercises] = Exercise.joins(:exercise_modification).joins(:entries).joins(entries: :ticket).joins(entries: {ticket: :user}).where("tickets.user_id = ?", current_user.id).where("exercise_modifications.date >= ?", Date.today).order("exercise_modifications.date")
          render "unsubscribe_from_user_summary_list", locals: {tickets: @data[:user].tickets}
        end
      end
    end
  end

  def admin_edit
    @data = {}
    get_mode(params[:mode])

    if @data[:mode] == :exercise
      @data[:registered] = User.joins(tickets: {entries: :exercise}).where("exercises.id = ?", @data[:object].id)
    else
      @data[:registered] = []
    end

    if @data[:mode] == :modification
      @data[:modification] = @data[:object]
    else
      if @data[:mode == :template]
        @data[:modification] = ExerciseModification.where(exercise_template_id: @data[:object].id).where("date::date = ?", @data[:date]).first
      else
        if @data[:mode] == :exercise
          @data[:modification] = @data[:object].exercise_modification
        end
      end
    end

    @data[:beginning_offset] = params[:beginning_offset].to_i
  end

  private

  def render_alert(message)
    render "application/alert.js", locals: {message: message}, status: 403
  end

  def ticket_selector(therapy, date)
    if params[:ticket_id]
      # ticket already selected
      return Ticket.find(params[:ticket_id])
    else
      tickets_available = Ticket.for_therapy(@data[:user].tickets.with_available_entries(date), therapy)

      if tickets_available.count > 0
        if tickets_available.count == 1
          # just one - no need for an additional form
          return tickets_available.first
        else
          # more than one - show js form
          @data[:tickets] = Ticket.for_therapy(@data[:user].tickets.where(single_use: false), therapy)
          @data[:target_therapy] = therapy
          render "ticket_selector_form.js.erb", status: 200 and return
        end
      else
        # any usable tickets were not found
        # try creating single use one
        single_use = Ticket.create_single_use(@data[:user], therapy)
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

  def get_mode(mode)
    @data = {} if !@data
    if mode.include?("template")
      @data[:object] = ExerciseTemplate.find(params[:id])
      @data[:date] = Date.parse(params[:date]).to_datetime.in_time_zone - Time.now.in_time_zone.utc_offset - (Time.now.in_time_zone.dst? ? 3600 : 0) + @data[:object].beginning.in_time_zone.seconds_since_midnight.seconds
      @data[:mode] = :template
      @data[:calendar] = @data[:object].timetable_template.calendar
    else
      if mode.include?("modification")
        @data[:object] = ExerciseModification.find(params[:id])
        @data[:mode] = :modification
        @data[:date] = @data[:object].date
        @data[:calendar] = @data[:object].timetable_modification.calendar
      else
        @data[:object] = Exercise.find(params[:id])
        @data[:mode] = :exercise
        @data[:date] = @data[:object].exercise_modification.date
        @data[:calendar] = @data[:object].timetable.calendar
      end
    end
    @data[:therapy] = @data[:calendar].therapy
  end
end