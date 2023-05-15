class OdsProjectsController < ApplicationController
  before_action :set_ods_project, only: %i[ show edit update destroy ]

  # GET /ods_projects or /ods_projects.json
  def index
    @ods_projects = OdsProject.all
  end

  # GET /ods_projects/1 or /ods_projects/1.json
  def show
  end

  # GET /ods_projects/new
  def new
    @ods_project = OdsProject.new
  end

  # GET /ods_projects/1/edit
  def edit
  end

  # POST /ods_projects or /ods_projects.json
  def create
    @ods_project = OdsProject.new(ods_project_params)

    respond_to do |format|
      if @ods_project.save
        format.html { redirect_to ods_project_url(@ods_project), notice: "Ods project was successfully created." }
        format.json { render :show, status: :created, location: @ods_project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ods_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ods_projects/1 or /ods_projects/1.json
  def update
    respond_to do |format|
      if @ods_project.update(ods_project_params)
        format.html { redirect_to ods_project_url(@ods_project), notice: "Ods project was successfully updated." }
        format.json { render :show, status: :ok, location: @ods_project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ods_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ods_projects/1 or /ods_projects/1.json
  def destroy
    @ods_project.destroy

    respond_to do |format|
      format.html { redirect_to ods_projects_url, notice: "Ods project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ods_project
      @ods_project = OdsProject.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ods_project_params
      params.require(:ods_project).permit(:name)
    end
end
