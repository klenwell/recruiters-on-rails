class PingsController < ApplicationController
  before_action :set_ping, only: [:show, :edit, :update, :destroy]

  # GET /pings
  # GET /pings.json
  def index
    @recruiter = Recruiter.find(params[:recruiter_id])
    @pings = @recruiter.pings.order('date DESC')
  end

  # GET /pings/1
  # GET /pings/1.json
  def show
  end

  # GET /pings/new
  def new
    @recruiter = Recruiter.find(params[:recruiter_id])
    @ping = Ping.new(recruiter_id: @recruiter.id, date: Date.today.to_s)
    @recruiters = Recruiter.all
  end

  # GET /pings/1/edit
  def edit
    @recruiter = Recruiter.find(params[:recruiter_id])
    @ping = @recruiter.pings.find(params[:id])
    @recruiters = Recruiter.all
  end

  # POST /pings
  # POST /pings.json
  def create
    @recruiter = Recruiter.find(params[:recruiter_id])
    @ping = @recruiter.pings.build(ping_params)

    respond_to do |format|
      if @ping.save
        format.html { redirect_to(
          edit_recruiter_path(id: @ping.recruiter_id),
          notice: 'Ping was successfully created.') }
        format.json { render :show, status: :created, location: @ping }
      else
        format.html { render :new }
        format.json { render json: @ping.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pings/1
  # PATCH/PUT /pings/1.json
  def update
    respond_to do |format|
      if @ping.update(ping_params)
        format.html { redirect_to(
          edit_recruiter_path(id: @ping.recruiter_id),
          notice: 'Ping was successfully updated.') }
        format.json { render :show, status: :ok, location: @ping }
      else
        format.html { render :edit }
        format.json { render json: @ping.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pings/1
  # DELETE /pings/1.json
  def destroy
    @ping.destroy
    respond_to do |format|
      format.html { redirect_to(
        edit_recruiter_path(id: @ping.recruiter_id),
        notice: 'Ping was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ping
      @ping = Ping.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ping_params
      params.require(:ping).permit(:recruiter, :recruiter_id, :kind, :note, :transcript, :value, :date)
    end
end
