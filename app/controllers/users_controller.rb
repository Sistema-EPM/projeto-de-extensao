class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]

  # GET /students or /students.json
  def index
    @context = "Alunos"
    @students = User.all.where(status: 1, is_responsible: false, organization_id: set_organization)
  end

  # GET /students/1 or /students/1.json
  def show
    @projects_by_student = @student.projects.includes(:reports)
  end

  # GET /students/new
  def new
    @user = User.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    unless current_user.is_responsible?
      redirect_to access_denied_path
    else
      organization = current_user.organization || Organization.where(admin_id: current_admin.id).first
      @student = User.new(user_params)
      @student.status = 1
      @student.organization = organization

      respond_to do |format|
        if @student.save
          format.html { redirect_to user_url(@student), notice: "Student was successfully created." }
          format.json { render :show, status: :created, location: @student }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(user_params)
        format.html { redirect_to user_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy_selected
    return "Nenhum aluno foi selecionado." unless params[:selected_ids].present?

    selected_ids = params[:selected_ids]
    if selected_ids.present?
      User.where(id: selected_ids).destroy_all
    else
      @student.destroy
    end

    respond_to do |format|
      format.html { redirect_to users_url, notice: "Aluno excluído com sucesso." }
      format.json { head :no_content }
    end
  end

  def search_student
    @name = params[:search]
    @students_by_name = User.where("LOWER(name) LIKE LOWER(?)", "%#{@name}%").where(is_responsible: false)
      .select(:name, :email, :status)
      .select("(SELECT COALESCE(SUM(r.reported_effort), 0) 
        FROM reports r WHERE r.user_id = users.id) AS reported_hours")

    @context = @students_by_name.present? ? "Resultados da busca" : "Nenhum aluno encontrado"
  end

  def show_inactive_students
    @context = "Alunos inativos"
    @inactive_students = User.all.where(status: 0, is_responsible: false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
    @student = User.find_by(id: params[:id])
  
    unless @student
      redirect_to users_url, alert: "Aluno não encontrado."
    end
  end
  

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :is_responsible)
    end
end
