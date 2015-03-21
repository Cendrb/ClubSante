json.array!(@timetable_templates) do |timetable_template|
  json.extract! timetable_template, :id
  json.url timetable_template_url(timetable_template, format: :json)
end
