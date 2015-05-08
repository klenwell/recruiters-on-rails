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

  # POST /lists
  # POST /lists.json
  def create
    @list = RecruiterList.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to lists_path, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
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
