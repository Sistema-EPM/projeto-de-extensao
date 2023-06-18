class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[ show edit update destroy ]

  # GET /assignments or /assignments.json
  def index
    @assignments = Assignment.all
  end

  # GET /assignments/1 or /assignments/1.json
  def show
  end

  # GET /assignments/new
  def new
    if has_permission?
      @assignment = Assignment.new
      @projects = Project.where(organization_id: set_organization.id)
      @users = User.joins(classroom: :projects).where(organization_id: set_organization.id, is_responsible: false)
    else
      redirect_to access_denied_path
    end
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments or /assignments.json
  def create
    if has_permission?
      @assignment = Assignment.new(assignment_params)

      respond_to do |format|
        if @assignment.save
          format.html { redirect_to projects_path, notice: "Assignment was successfully created." }
          format.json { render :show, status: :created, location: @assignment }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @assignment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # PATCH/PUT /assignments/1 or /assignments/1.json
  def update
    if has_permission?
      respond_to do |format|
        if @assignment.update(assignment_params)
          format.html { redirect_to assignment_url(@assignment), notice: "Assignment was successfully updated." }
          format.json { render :show, status: :ok, location: @assignment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @assignment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # DELETE /assignments/1 or /assignments/1.json
  def destroy
    if has_permission?
      @assignment.destroy

      respond_to do |format|
        format.html { redirect_to assignments_url, notice: "Assignment was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to access_denied_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assignment_params
      params.require(:assignment).permit(:user_id, :project_id)
    end
end
