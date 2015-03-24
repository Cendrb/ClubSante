json.array!(@exercise_templates) do |exercise_template|
  json.extract! exercise_template, :id
  json.url exercise_template_url(exercise_template, format: :json)
end
