json.array!(@exercise_modifications) do |exercise_modification|
  json.extract! exercise_modification, :id, :exercise_template_id, :date, :coach_id, :price, :note, :timetable_template_id
  json.url exercise_modification_url(exercise_modification, format: :json)
end
