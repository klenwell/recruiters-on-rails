class RecruitersController < ApplicationController
  before_action :set_recruiter, only: [:show, :edit, :update, :destroy]

  # GET /recruiters
  # GET /recruiters.json
  def index
    @search = RecruiterSearch.new(search_params)

    if search_params.present?
      @recruiters  = @search.results
    else
      @recruiters = Recruiter.recently_pinged
    end

    @recruiters = @recruiters.sorted(sort_by, sort_in) if sorted?
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
        format.html { redirect_to new_recruiter_ping_path(@recruiter),
          notice: 'Recruiter was successfully created. Please add a ping.' }
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

    if params[:file].blank?
      flash[:error] = 'Please choose a file.'
      return redirect_to import_recruiters_path
    else
      file = params[:file]
    end

    # Simple file type detection for zip file
    if file.original_filename.ends_with?('.zip')
      require 'zip'
      csv_file = Zip::File.open(file.path).glob('*.csv').first
      file_path = File.join("/tmp", csv_file.name)
      csv_file.extract(file_path) unless File.exist?(file_path)
    else
      file_path = file.path
    end

    # Parse file
    SmarterCSV.process(file_path).each do |row|
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
        @file_name = file.original_filename
        @recruiters = recruiters
        format.html { render :review_import }
      end
    end
  end

  # GET /recruiters/typeahead/:query
  def typeahead
    @search  = RecruiterSearch.new(typeahead: params[:query])
    render json: @search.results
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

  def search_params
    params[:recruiter_search] || {}
  end
end
