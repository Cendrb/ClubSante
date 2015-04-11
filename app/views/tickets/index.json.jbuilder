json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :time_restriction, :entries_remaining, :activated_on, :paid, :user_id
  json.url ticket_url(ticket, format: :json)
end
