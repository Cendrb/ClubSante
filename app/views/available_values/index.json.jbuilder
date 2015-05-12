json.array!(@available_values) do |available_value|
  json.extract! available_value, :id, :name
  json.url available_value_url(available_value, format: :json)
end
