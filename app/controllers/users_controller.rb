class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]
  before_action :set_responsible, only: %i[ show_responsible edit_responsible update_responsible ]

  # GET /students or /students.json
  def index
    if has_permission?
      @context = "Alunos"
      @students = User.all.where(status: 1, is_responsible: false, organization_id: set_organization)
    elsif user_signed_in?
      @context = "Meus dados"
      @students = User.where(id: current_user.id, status: 1)
    else
      redirect_to access_denied_path
    end
  end

  def index_responsibles
    if admin_signed_in?
      @context = "Coordenadores"
      @responsibles = User.all.where(status: 1, is_responsible: true, organization_id: set_organization)
    else
      redirect_to access_denied_path
    end
  end

  # GET /students/1 or /students/1.json
  def show
  end

  def show_responsible
  end

  # GET /students/new
  def new
    @user = User.new
    @context = "Novo Aluno"
    if admin_signed_in?
      @classrooms = Classroom.joins(course: :user).where(users: { organization_id: set_organization.id })
    elsif user_signed_in? && current_user.is_responsible
      @classrooms = Classroom.joins(course: :user).where(courses: { user_id: current_user.id })
    end
  end

  def new_responsible
    @responsible = User.new
  end

  # GET /students/1/edit
  def edit
    @context = "Editar Aluno"
    @classrooms = Classroom.joins(course: :user).where(users: { organization_id: set_organization.id })
  end

  def edit_responsible
  end

  # POST /students or /students.json
  def create
    if has_permission?
      organization = current_user.try(:organization) || Organization.where(admin_id: current_admin.id).first
      @student = User.new(user_params)
      @student.status = 1
      @student.organization = organization
      @student.is_responsible = false

      respond_to do |format|
        if @student.save
          format.html { redirect_to user_url(@student), notice: "Student was successfully created." }
          format.json { render :show, status: :created, location: @student }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  def create_responsible
    if admin_signed_in?
      organization = Organization.where(admin_id: current_admin.id).first
      @responsible = User.new(responsible_params)
      @responsible.status = 1
      @responsible.organization = organization
      @responsible.is_responsible = true

      respond_to do |format|
        if @responsible.save
          format.html { redirect_to responsibles_path, notice: "Coordenador criado com sucesso." }
          format.json { render :show_responsible, status: :created, location: @responsible }
        else
          format.html { render :new_responsible, status: :unprocessable_entity }
          format.json { render json: @responsible.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    if has_permission?
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
  end

  def update_responsible
    if has_permission?
      respond_to do |format|
        if @responsible.update(user_params)
          format.html { redirect_to responsible_url(@responsible), notice: "Responsible was successfully updated." }
          format.json { render :show_responsible, status: :ok, location: @responsible }
        else
          format.html { render :edit_responsible, status: :unprocessable_entity }
          format.json { render json: @responsible.errors, status: :unprocessable_entity }
        end
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
    @students_by_name = User.where("LOWER(name) LIKE LOWER(?)", "%#{@name}%").where(is_responsible: false, organization_id: set_organization.id)
      .select(:name, :email, :status)
      .select("(SELECT COALESCE(SUM(r.reported_effort), 0) 
        FROM reports r WHERE r.user_id = users.id) AS reported_hours")

    @context = @students_by_name.present? ? "Resultados da busca" : "Nenhum aluno encontrado"
  end

  def show_inactive_students
    @context = "Alunos inativos"
    @inactive_students = User.all.where(status: 0, is_responsible: false)
  end

  def reports
    @user = User.find(params[:id])
    @reports = @user.reports
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @student = User.find_by(id: params[:id])
    
      unless @student
        redirect_to users_url, alert: "Aluno não encontrado."
      end
    end

    def set_responsible
      @responsible = User.find_by(id: params[:id])
    
      unless @responsible
        redirect_to responsibles_url, alert: "Coordenador não encontrado."
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :classroom_id)
    end

    def responsible_params
      params.require(:user).permit(:name, :email, :password)
    end
end
