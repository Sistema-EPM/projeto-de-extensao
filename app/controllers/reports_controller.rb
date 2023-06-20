class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update ]

  # GET /reports or /reports.json
  def index
    @context = "Reportes"
    if user_signed_in? && !current_user.is_responsible
      @reports = Report.joins(:user).where(users: { id: current_user.id })
      @projects = Project.includes(:users, :reports).joins(:assignments).where(users: { id: current_user.id })
    else
      redirect_to access_denied_path
    end
  end

  # GET /reports/1 or /reports/1.json
  def show
    @context = "Dados do Reporte"
  end

  # GET /reports/new
  def new
    @context = "Novo Reporte"
    if user_signed_in? && !current_user.is_responsible
      @report = Report.new
      @projects = Project.joins(:assignments).where(status: "Em andamento", assignments: { user_id: current_user.id }).distinct
    else
      redirect_to access_denied_path
    end
  end

  # GET /reports/1/edit
  def edit
    @context = "Editando Reporte"
    @projects = Project.joins(:assignments).where(status: "Em andamento", assignments: { user_id: current_user.id }).distinct
  end

  # POST /reports or /reports.json
  def create
    if current_user.present? && !current_user.try(:is_responsible)
      @report = Report.new(report_params)
      @report.user_id = current_user.id

      respond_to do |format|
        if @report.save
          format.html { redirect_to report_url(@report), notice: "Report was successfully created." }
          format.json { render :show, status: :created, location: @report }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    if current_user.present? && !current_user.try(:is_responsible)
      respond_to do |format|
        if @report.update(report_params)
          format.html { redirect_to report_url(@report), notice: "Report was successfully updated." }
          format.json { render :show, status: :ok, location: @report }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    if has_permission?
      return "Nenhum aluno foi selecionado." unless params[:selected_ids].present?

      selected_ids = params[:selected_ids]
      if selected_ids.present?
        Report.where(id: selected_ids).destroy_all
      else
        @report.destroy
      end

      respond_to do |format|
        format.html { redirect_to reports_url, notice: "Reporte excluído com sucesso." }
        format.json { head :no_content }
      end
    else
      redirect_to access_denied_path
    end
  end

  def approve_reports
    if has_permission?
      selected_ids = params[:selected_ids] || []
      reports = Report.where(id: selected_ids)
      reports.update_all(status: true)
    else
      redirect_to access_denied_path
    end
  end

  def reprove_reports
    if has_permission?
      selected_ids = params[:selected_ids] || []
      reports = Report.where(id: selected_ids)
      reports.update_all(status: false)
    else
      redirect_to access_denied_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:reported_effort, :reported_date, :status, :project_id, :user_id, :file)
    end
end
