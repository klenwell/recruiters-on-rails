class PingsController < ApplicationController
  before_action :set_ping, only: [:show, :edit, :update, :destroy]

  # GET /pings
  # GET /pings.json
  def index
    @pings = Ping.all
  end

  # GET /pings/1
  # GET /pings/1.json
  def show
  end

  # GET /pings/new
  def new
    @ping = Ping.new
  end

  # GET /pings/1/edit
  def edit
  end

  # POST /pings
  # POST /pings.json
  def create
    @ping = Ping.new(ping_params)

    respond_to do |format|
      if @ping.save
        format.html { redirect_to @ping, notice: 'Ping was successfully created.' }
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
        format.html { redirect_to @ping, notice: 'Ping was successfully updated.' }
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
      format.html { redirect_to pings_url, notice: 'Ping was successfully destroyed.' }
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
      params.require(:ping).permit(:recruiter, :kind, :note, :transcript, :value, :date)
    end
end
