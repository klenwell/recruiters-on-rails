class MeritsController < ApplicationController
  before_action :set_merit, only: [:show, :edit, :update, :destroy]

  # GET /merits
  # GET /merits.json
  def index
    @recruiter = Recruiter.find(params[:recruiter_id])
    @merits = @recruiter.merits.order('date DESC')
  end

  # GET /merits/new
  def new
    @label = params[:demerit] ? 'demerit' : 'merit'
    @recruiter = Recruiter.find(params[:recruiter_id])
    @merit = Merit.new(recruiter_id: @recruiter.id)
    @recruiters = Recruiter.all
  end

  # POST /merits
  # POST /merits.json
  def create
    @recruiter = Recruiter.find(params[:recruiter_id])
    @merit = @recruiter.merits.build(merit_params)

    respond_to do |format|
      if @merit.save
        format.html { redirect_to recruiters_path, notice: 'Merit was successfully created.' }
        format.json { render :show, status: :created, location: @merit }
      else
        format.html { render :new }
        format.json { render json: @merit.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /merits/1/edit
  def edit
    @recruiter = Recruiter.find(params[:recruiter_id])
    @merit = @recruiter.merits.find(params[:id])
    @label = @merit.is_demerit? ? 'demerit' : 'merit'
    @recruiters = Recruiter.all
  end

  # PATCH/PUT /merits/1
  # PATCH/PUT /merits/1.json
  def update
    respond_to do |format|
      if @merit.update(merit_params)
        format.html { redirect_to(
          edit_recruiter_path(id: @merit.recruiter_id),
          notice: 'Merit was successfully updated.') }
        format.json { render :show, status: :ok, location: @merit }
      else
        format.html { render :edit }
        format.json { render json: @merit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /merits/1
  # DELETE /merits/1.json
  def destroy
    @merit.destroy
    respond_to do |format|
      format.html { redirect_to recruiters_path, notice: 'Merit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merit
      @merit = Merit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def merit_params
      params.require(:merit).permit(:recruiter, :recruiter_id, :reason, :value, :date)
    end
end
