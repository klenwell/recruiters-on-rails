class RecruiterListsController < ApplicationController

  # GET /lists
  # GET /lists.json
  def index
    @lists = RecruiterList.all
  end

  # GET /lists/new
  def new
    @list = RecruiterList.new
  end

  # GET /lists/edit
  def edit
    @list = RecruiterList.find(params[:id])
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = RecruiterList.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to recruiter_lists_path, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    @list = RecruiterList.find(params[:id])

    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to recruiter_lists_path, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def list_params
    params.require(:recruiter_list).permit(:name)
  end
end
