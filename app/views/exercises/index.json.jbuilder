json.array!(@exercises) do |exercise|
  json.extract! exercise, :id, :beginning, :exercise_day_id
  json.url exercise_url(exercise, format: :json)
end
