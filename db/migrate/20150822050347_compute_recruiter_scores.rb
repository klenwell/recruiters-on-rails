class ComputeRecruiterScores < ActiveRecord::Migration
  def up
    # before_save callback will compute score.
    Recruiter.all.each do |recruiter|
       recruiter.save!
    end
  end
end
