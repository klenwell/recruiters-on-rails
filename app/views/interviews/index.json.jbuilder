json.array!(@interviews) do |interview|
  json.extract! interview, :id, :recruiter_id, :date, :company, :culture, :people, :work, :career, :commute, :salary, :gut
  json.url interview_url(interview, format: :json)
end
