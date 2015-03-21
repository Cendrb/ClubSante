json.array!(@users) do |user|
  json.extract! user, :id, :email, :first_name, :last_name, :hashed_password, :salt, :access_level
  json.url user_url(user, format: :json)
end
