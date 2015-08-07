json.array!(@timetable_modifications) do |timetable_modification|
  json.extract! timetable_modification, :id, :calendar_id
  json.url timetable_modification_url(timetable_modification, format: :json)
end
