class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update ]

  # GET /courses or /courses.json
  def index
    if admin_signed_in?
      @courses = Course.joins(:user).where(users: { organization_id: set_organization.id })
    else
      redirect_to access_denied_path
    end
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    if admin_signed_in?
      @course = Course.new
      @users = User.where(is_responsible: true, organization_id: set_organization.id)
      @users = @users.any? ? @users : []
    else
      redirect_to access_denied_path
    end
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    if admin_signed_in?
      @course = Course.new(course_params)

      respond_to do |format|
        if @course.save
          format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
          format.json { render :show, status: :created, location: @course }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    if admin_signed_in?
      respond_to do |format|
        if @course.update(course_params)
          format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
          format.json { render :show, status: :ok, location: @course }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    if has_permission?
      return "Nenhum aluno foi selecionado." unless params[:selected_ids].present?

      selected_ids = params[:selected_ids]
      if selected_ids.present?
        Course.where(id: selected_ids).destroy_all
      else
        @course.destroy
      end

      respond_to do |format|
        format.html { redirect_to courses_url, notice: "Curso excluído com sucesso." }
        format.json { head :no_content }
      end
    else
      redirect_to access_denied_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :user_id)
    end
end
