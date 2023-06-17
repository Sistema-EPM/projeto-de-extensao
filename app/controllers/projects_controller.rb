class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]

  # GET /projects or /projects.json
  def index
    if admin_signed_in?
      @context = "Projetos"
      @projects = Project.all.where(organization_id: set_organization)
    elsif has_permission?
      @context = "Projetos"
      @projects = Project.joins(classroom: :course).where(courses: { user_id: current_user.id })
    elsif user_signed_in?
      @context = "Meus projetos"
      @projects = Project.includes(:users, :reports).joins(:assignments).where(users: { id: current_user.id })
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    if has_permission?
      @project = Project.new
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    if has_permission?
      @project = Project.new(project_params)

      respond_to do |format|
        if @project.save
          format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    if has_permission?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
          format.json { render :show, status: :ok, location: @project }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    if has_permission?
      @project.destroy

      respond_to do |format|
        format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  def search_project
    @name = params[:search]
    @projects_by_name = Project.where("LOWER(name) LIKE LOWER(?)", "%#{@name}%").where(organization_id: set_organization.id)
      .select(:name, :description, :competency, :status)
      .select("(SELECT COALESCE(SUM(r.reported_effort), 0) 
        FROM reports r WHERE r.project_id = projects.id) AS reported_hours")
  end

  def show_students_in_project
    @students_in_project = User.joins(:assignments).where(assignments: { project_id: params[:id] })
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.permit(:name, :competency, :status, :modality, :description, :course_id, :responsible_id, :ods_project_id, :feedback_id, :organization_id)
    end
end
