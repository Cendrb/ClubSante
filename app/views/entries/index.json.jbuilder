json.array!(@entries) do |entry|
  json.extract! entry, :id, :exercise_id, :ticket_id, :user_id, :message
  json.url entry_url(entry, format: :json)
end
