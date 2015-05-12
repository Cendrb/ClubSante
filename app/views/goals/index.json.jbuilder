json.array!(@goals) do |goal|
  json.extract! goal, :id, :tracked_value_id, :value, :date
  json.url goal_url(goal, format: :json)
end
