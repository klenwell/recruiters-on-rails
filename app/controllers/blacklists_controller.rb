class BlacklistsController < ApplicationController

  # GET /blacklists
  def index
    @blacklists = Blacklist.indexed
  end

  # POST /blacklists.json
  # create -> see recruiters#blacklist

  # PUT /blacklists/1.json
  # update -> see recruiters#unblacklist

end
