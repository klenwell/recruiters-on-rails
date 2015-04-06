json.array!(@pings) do |ping|
  json.extract! ping, :id, :recruiter, :kind, :note, :transcript, :value, :date
  json.url ping_url(ping, format: :json)
end
