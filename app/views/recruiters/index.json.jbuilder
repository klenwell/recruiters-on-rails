json.array!(@recruiters) do |recruiter|
  json.extract! recruiter, :id, :first_name, :last_name, :email, :company, :phone
  json.url recruiter_url(recruiter, format: :json)
end
