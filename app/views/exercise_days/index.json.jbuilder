json.array!(@exercise_days) do |exercise_day|
  json.extract! exercise_day, :id, :date
  json.url exercise_day_url(exercise_day, format: :json)
end
