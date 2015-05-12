json.array!(@tracked_values) do |tracked_value|
  json.extract! tracked_value, :id, :user_id, :available_value_id
  json.url tracked_value_url(tracked_value, format: :json)
end
