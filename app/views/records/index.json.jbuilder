json.array!(@records) do |record|
  json.extract! record, :id, :tracked_value_id, :value, :date
  json.url record_url(record, format: :json)
end
