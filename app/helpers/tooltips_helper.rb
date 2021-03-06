module TooltipsHelper
  def get_calendar_tooltip(object)
    string = ""

    if (Rails.env.development?)
      string << get_development_prefix(object) + br
    end

    string << get_time_range_string(object) + br
    string << get_duration_string(object) + br
    string << get_capacity_string(object)
    string << get_coach_string(object)
    string << get_price_string(object)

    return string
  end

  def get_modification_tooltip(object)
    string = ""

    if (Rails.env.development?)
      string << get_development_prefix(object) + br
    end

    string << get_time_range_string(object) + br
    string << get_duration_string(object) + br
    string << get_capacity_string(object)
    string << get_coach_string(object)
    string << get_price_string(object) + br
    string << get_modification_string(object) + br
    string << get_modification_user_string(object)

    return string
  end

  def get_template_tooltip(object)
    string = ""

    if (Rails.env.development?)
      string << get_development_prefix(object) + br
    end

    string << get_time_range_string(object) + br
    string << get_duration_string(object) + br
    string << get_capacity_string(object)
    string << get_coach_string(object)
    string << get_price_string(object)

    return string
  end

  def get_time_range_string(object)
    case object
      when Exercise
        return "#{get_beginning_string(object)} - #{(object.exercise_modification.date + object.timetable.calendar.therapy.duration_in_minutes.minutes).to_s(:time)}"
      when ExerciseTemplate
        return "#{get_beginning_string(object)} - #{(object.beginning + object.timetable_template.calendar.therapy.duration_in_minutes.minutes).to_s(:time)}"
      when ExerciseModification
        return "#{get_beginning_string(object)} - #{(object.date + object.timetable_modification.calendar.therapy.duration_in_minutes.minutes).to_s(:time)}"
      else
        return unsupported
    end
  end

  def get_capacity_string(object)
    case object
      when Exercise
        return "obsazeno #{object.entries.count} z #{object.timetable.calendar.therapy.capacity}"
      when ExerciseTemplate
        return "obsazeno 0 z #{object.timetable_template.calendar.therapy.capacity}"
      when ExerciseModification
        return "obsazeno 0 z #{object.timetable_modification.calendar.therapy.capacity}"
      else
        return unsupported
    end
    return string
  end

  def get_duration_string(object)
    case object
      when Exercise
        return "#{object.timetable.calendar.therapy.duration_in_minutes} minut"
      when ExerciseTemplate
        return "#{object.timetable_template.calendar.therapy.duration_in_minutes} minut"
      when ExerciseModification
        return "#{object.timetable_modification.calendar.therapy.duration_in_minutes} minut"
      else
        return unsupported
    end
  end

  def get_beginning_string(object)
    case object
      when Exercise
        return object.exercise_modification.date.to_s(:time)
      when ExerciseTemplate
        return object.beginning.to_s(:time)
      when ExerciseModification
        return object.date.to_s(:time)
      else
        return unsupported
    end
  end

  def get_coach_string(object)
    case object
      when Exercise
        return (!object.exercise_modification.coach.nil? && object.exercise_modification.coach != Coach.get_nobody) ? (br + object.exercise_modification.coach.name) : ""
      when ExerciseTemplate
        return (!object.coach.nil? && object.coach != Coach.get_nobody) ? (br + object.coach.name) : ""
      when ExerciseModification
        return (!object.coach.nil? && object.coach != Coach.get_nobody) ? (br + object.coach.name) : ""
      else
        return unsupported
    end
  end

  def get_price_string(object)
    case object
      when Exercise
        return object.exercise_modification.price != ExerciseTemplate.get_hide_string ? (br + object.exercise_modification.price) : ""
      when ExerciseTemplate
        return object.price != ExerciseTemplate.get_hide_string ? (br + object.price) : ""
      when ExerciseModification
        return object.price != ExerciseTemplate.get_hide_string ? (br + object.price) : ""
      else
        return unsupported
    end
  end

  def get_modification_string(object)
    case object
      when Exercise
        return ""
      when ExerciseTemplate
        return ""
      when ExerciseModification
        if (object.removal)
          return "odstraňuje obvyklé cvičení"
        else
          if (object.exercise_template == nil)
            return "přidává cvičení"
          else
            if (object.differs_from_template?)
              return "mění vlastnosti obvyklého cvičení"
            else
              if (object.exercise)
                return "pouze přihlášení uživatelé"
              else
                return "nic nemění"
              end
            end
          end
        end
      else
        return unsupported
    end
  end

  def get_modification_user_string(object)
    case object
      when Exercise
        return ""
      when ExerciseTemplate
        return ""
      when ExerciseModification
        if (object.exercise)
          return User.where("entries.exercise_id = ?", object.exercise.id).joins(tickets: :entries).map { |i| i.full_name }.to_sentence
        else
          return ""
        end
      else
        return unsupported
    end
  end

  def get_development_prefix(object)
    case object
      when Exercise
        return "FINAL EXERCISE"
      when ExerciseTemplate
        return "TEMPLATE"
      when ExerciseModification
        return "MODIFICATION"
      else
        return unsupported
    end
  end

  def br
    return "<br />"
  end

  def unsupported
    return "UNSUPPORTED"
  end

end