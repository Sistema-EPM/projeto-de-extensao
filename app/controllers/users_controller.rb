class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]
  before_action :set_responsible, only: %i[ show_responsible edit_responsible update_responsible ]

  # GET /students or /students.json
  def index
    if admin_signed_in?
      @context = "Alunos"
      @students = User.all.where(status: 1, is_responsible: false, organization_id: set_organization)
    elsif has_permission?
      @context = "Alunos"
      @students = User.joins(classroom: :course).where(status: 1, is_responsible: false, organization_id: set_organization.id, courses: { user_id: current_user.id })
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
    @context = "Dados do Aluno"
    @projects_by_student = @student.projects.includes(:reports).distinct
  end

  def show_responsible
    @context = "Dados do Coordenador"
  end

  # GET /students/new
  def new
    if has_permission?
      @user = User.new
      @context = "Novo Aluno"
      if admin_signed_in?
        @classrooms = Classroom.joins(course: :user).where(users: { organization_id: set_organization.id })
      elsif user_signed_in? && current_user.is_responsible
        @classrooms = Classroom.joins(course: :user).where(courses: { user_id: current_user.id })
      end
    else
      redirect_to access_denied_path
    end
  end

  def new_responsible
    @context = "Novo Coordenador"
    if admin_signed_in?
      @responsible = User.new
    else
      redirect_to access_denied_path
    end
  end

  # GET /students/1/edit
  def edit
    if has_permission?
      @context = "Editando Aluno"
      @classrooms = Classroom.joins(course: :user).where(users: { organization_id: set_organization.id })
    else
      redirect_to access_denied_path
    end
  end

  def edit_responsible
    @context = "Editando Coordenador"
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
        if @student.classroom_id.nil?
          flash[:alert] = "Não foi possível criar aluno, turma não pode ficar vazio."
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        elsif @student.save
          flash[:notice] = "Aluno criado com sucesso."
          format.html { redirect_to user_url(@student) }
          format.json { render :show, status: :created, location: @student }
        else
          flash[:alert] = "Não foi possível criar aluno."
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
          flash[:notice] = "Coordenador criado com sucesso."
          format.html { redirect_to responsibles_path }
          format.json { render :show_responsible, status: :created, location: @responsible }
        else
          flash[:alert] = "Não foi possível criar coordenador."
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
          flash[:notice] = "Aluno atualizado com sucesso."
          format.html { redirect_to user_url(@student) }
          format.json { render :show, status: :ok, location: @student }
        else
          flash[:alert] = "Não foi possível atualizar aluno."
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  def update_responsible
    if admin_signed_in?
      respond_to do |format|
        if @responsible.update(user_params)
          flash[:notice] = "Coordenador criado com sucesso."
          format.html { redirect_to responsible_url(@responsible) }
          format.json { render :show_responsible, status: :ok, location: @responsible }
        else
          flash[:alert] = "Não foi possível atualizar coordenador."
          format.html { render :edit_responsible, status: :unprocessable_entity }
          format.json { render json: @responsible.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    if has_permission?
      return "Nenhum aluno foi selecionado." unless params[:selected_ids].present?

      selected_ids = params[:selected_ids]
      if selected_ids.present?
        User.where(id: selected_ids).destroy_all
      else
        @student.destroy
      end

      respond_to do |format|
        flash[:notice] = "Aluno excluído com sucesso."
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      redirect_to access_denied_path
    end
  end

  def destroy_responsibles
    if admin_signed_in?
      return "Nenhum coordenador foi selecionado." unless params[:selected_ids].present?

      selected_ids = params[:selected_ids]
      if selected_ids.present?
        User.where(id: selected_ids).destroy_all
      else
        @responsible.destroy
      end

      respond_to do |format|
        flash[:notice] = "Coordenador excluído com sucesso."
        format.html { redirect_to responsibles_url }
        format.json { head :no_content }
      end
    else
      redirect_to access_denied_path
    end
  end

  def search_student
    @name = params[:search]
    if admin_signed_in?
      @students_by_name = User.where("LOWER(name) LIKE LOWER(?)", "%#{@name}%").where(is_responsible: false, organization_id: set_organization.id)
      .select(:name, :email, :status, :classroom_id)
      .select("(SELECT COALESCE(SUM(r.reported_effort), 0) 
        FROM reports r WHERE r.user_id = users.id) AS reported_hours")
    elsif has_permission?
      @students_by_name = User.joins(classroom: :course).where("LOWER(users.name) LIKE LOWER(?)", "%#{@name}%").where(status: 1, is_responsible: false, organization_id: set_organization.id, courses: { user_id: current_user.id })
        .select(:name, :email, :status, :classroom_id)
        .select("(SELECT COALESCE(SUM(r.reported_effort), 0) 
          FROM reports r WHERE r.user_id = users.id) AS reported_hours")
    else
      redirect_to access_denied_path
    end

    @context = @students_by_name.present? ? "Resultados da busca" : "Nenhum aluno encontrado"
  end

  def show_inactive_students
    if has_permission?
      @context = "Alunos inativos"
      @inactive_students = User.all.where(status: 0, is_responsible: false)
    else
      redirect_to access_denied_path
    end
  end

  def reports
    if has_permission?
      @user = User.find(params[:id])
      @reports = @user.reports
    else
      redirect_to access_denied_path
    end
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
