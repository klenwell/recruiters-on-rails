class RecruitersController < ApplicationController
  before_action :set_recruiter, only: [:show, :edit, :update, :destroy]

  # GET /recruiters
  # GET /recruiters.json
  def index
    @recruiters = Recruiter.recently_pinged
  end

  # GET /recruiters/1
  # GET /recruiters/1.json
  def show
  end

  # GET /recruiters/new
  def new
    @recruiter = Recruiter.new
  end

  # GET /recruiters/1/edit
  def edit
  end

  # POST /recruiters
  # POST /recruiters.json
  def create
    @recruiter = Recruiter.new(recruiter_params)

    respond_to do |format|
      if @recruiter.save
        format.html { redirect_to recruiters_path, notice: 'Recruiter was successfully created.' }
        format.json { render :show, status: :created, location: @recruiter }
      else
        format.html { render :new }
        format.json { render json: @recruiter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recruiters/1
  # PATCH/PUT /recruiters/1.json
  def update
    respond_to do |format|
      if @recruiter.update(recruiter_params)
        format.html { redirect_to recruiters_path, notice: 'Recruiter was successfully updated.' }
        format.json { render :show, status: :ok, location: @recruiter }
      else
        format.html { render :edit }
        format.json { render json: @recruiter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recruiters/1
  # DELETE /recruiters/1.json
  def destroy
    @recruiter.destroy
    respond_to do |format|
      format.html { redirect_to recruiters_url, notice: 'Recruiter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /recruiters/import
  def import
  end

  # POST /recruiters/process_import
  def process_import
    recruiters = {
      imported: [],
      duplicated: [],
      invalid: []
    }

    file = params[:file]
    #p file.original_filename

    SmarterCSV.process(file).each do |row|
      recruiter = Recruiter.create_from_import(row)

      if recruiter.persisted?
        recruiters[:imported] << recruiter
      elsif recruiter.errors.added? :email, :taken
        recruiters[:duplicated] << recruiter
      else
        recruiters[:invalid] << recruiter
      end
    end

    respond_to do |format|
      if recruiters[:imported].length == recruiters.values.map{|a| a.length}.sum
        format.html {
          redirect_to recruiters_path,
          notice: format('All %d recruiters were successfully imported.',
                         recruiters[:imported].length)
        }
      else
        # TODO: Add review view
        #@recruiters = recruiters
        #format.html { render :review_import }
        format.html {
          redirect_to recruiters_path,
          notice: 'PROBLEM'
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recruiter
      @recruiter = Recruiter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recruiter_params
      params.require(:recruiter).permit(:first_name, :last_name, :email, :company, :phone)
    end
end
