json.array!(@therapies) do |therapy|
  json.extract! therapy, :id, :name, :capacity, :duration_in_minutes
  json.url therapy_url(therapy, format: :json)
end
