module ColorsHelper
  def get_calendar_color(object)
    case object
      when Exercise
        return object.signed_up?(current_user) ? Coach.signed_color : (object.full? ? Coach.full_color : (object.exercise_modification.coach && object.exercise_modification.coach.color_code) ? object.exercise_modification.coach.color_code : Coach.default_color)
      when ExerciseTemplate
        return (object.coach && object.coach.color_code) ? object.coach.color_code : Coach.default_color
      when ExerciseModification
        return (object.coach && object.coach.color_code) ? object.coach.color_code : Coach.default_color
      else
        return Coach.default_color
    end
  end
end