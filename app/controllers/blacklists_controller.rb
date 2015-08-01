class BlacklistsController < ApplicationController

  # POST /pings.json
  def create
    blacklist_saved = nil
    error = nil
    recruiter = Recruiter.find(params[:recruiter_id])
    blacklist = recruiter.blacklists.build(blacklist_params.merge({recruiter_id: recruiter.id}))

    Blacklist.transaction do
      begin
        blacklist.save!
        Merit.create!({
          recruiter_id: recruiter.id,
          reason: 'Blacklisted!',
          value: blacklist.demerit_value,
          date: Date.today
        })
        blacklist_saved = true
      rescue Exception => e
        blacklist_saved = false
        error = e.to_s
        raise ActiveRecord::Rollback
      end
    end

    respond_to do |format|
      if blacklist_saved
        format.json { render json: blacklist, status: :created }
      else
        format.json { render json: {error: error}, status: :unprocessable_entity }
      end
    end
  end

  private

  def blacklist_params
    params.require(:blacklist).permit(:recruiter, :recruiter_id, :color, :reason)
  end

end
