class ClassroomsController < ApplicationController
  before_action :set_classroom, only: %i[ show edit update ]

  # GET /classrooms or /classrooms.json
  def index
    @context = "Turmas"
    if admin_signed_in?
      @classrooms = Classroom.joins(course: :user).where(users: { organization_id: set_organization.id })
    elsif has_permission?
      @classrooms = Classroom.joins(course: :user).where(users: { organization_id: set_organization.id }, courses: { user_id: current_user.id })
    else
      redirect_to access_denied_path
    end
  end

  # GET /classrooms/1 or /classrooms/1.json
  def show
  end

  # GET /classrooms/new
  def new
    if has_permission?
      @classroom = Classroom.new
      @courses = Course.joins(:user).where(users: { organization_id: set_organization.id })
    else
      redirect_to access_denied_path
    end
  end

  # GET /classrooms/1/edit
  def edit
  end

  # POST /classrooms or /classrooms.json
  def create
    if has_permission?
      @classroom = Classroom.new(classroom_params)

      respond_to do |format|
        if @classroom.save
          format.html { redirect_to classroom_url(@classroom), notice: "Classroom was successfully created." }
          format.json { render :show, status: :created, location: @classroom }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @classroom.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # PATCH/PUT /classrooms/1 or /classrooms/1.json
  def update
    if has_permission?
      respond_to do |format|
        if @classroom.update(classroom_params)
          format.html { redirect_to classroom_url(@classroom), notice: "Classroom was successfully updated." }
          format.json { render :show, status: :ok, location: @classroom }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @classroom.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # DELETE /classrooms/1 or /classrooms/1.json
  def destroy
    if has_permission?
      return "Nenhuma turma foi selecionada." unless params[:selected_ids].present?

      selected_ids = params[:selected_ids]
      if selected_ids.present?
        Classroom.where(id: selected_ids).destroy_all
      else
        @classroom.destroy
      end

      respond_to do |format|
        format.html { redirect_to classrooms_url, notice: "Turma excluída com sucesso." }
        format.json { head :no_content }
      end
    else
      redirect_to access_denied_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classroom
      @classroom = Classroom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def classroom_params
      params.require(:classroom).permit(:name, :start_date, :end_date, :status, :course_id)
    end
end
