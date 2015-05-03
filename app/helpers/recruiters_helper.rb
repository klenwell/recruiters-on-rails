module RecruitersHelper
  def score_class(recruiter)
    if recruiter.score > 0
      'positive'
    elsif recruiter.score < 0
      'negative'
    else
      ''
    end
  end
end
