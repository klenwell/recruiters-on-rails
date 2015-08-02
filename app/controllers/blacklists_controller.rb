class BlacklistsController < ApplicationController

  # POST /pings.json
  def create
    recruiter = Recruiter.find(params[:recruiter_id])
    @blacklist = recruiter.blacklist(blacklist_params[:reason], blacklist_params[:color])

    respond_to do |format|
      if @blacklist.persisted?
        format.js {
          flash[:notice] = 'Recruiter has been blacklisted!'
          flash.keep(:notice)
          render js: "window.location = '#{recruiter_path(recruiter)}'"
        }
      else
        format.js { render status: :unprocessable_entity }
      end
    end
  end

  private

  def blacklist_params
    params.require(:blacklist).permit(:recruiter, :recruiter_id, :color, :reason)
  end

end
