json.array!(@therapy_categories) do |therapy_category|
  json.extract! therapy_category, :id, :name
  json.url therapy_category_url(therapy_category, format: :json)
end
