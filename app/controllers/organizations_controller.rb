class OrganizationsController < ApplicationController
  before_action :set_local_organization, only: %i[ show edit update destroy ]

  # GET /organizations or /organizations.json
  def index
    if admin_signed_in?
      @organizations = Organization.where(id: set_organization.id)
    else
      redirect_to access_denied_path
    end
  end

  # GET /organizations/1 or /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    if admin_signed_in?
      @organization = Organization.new
    else
      redirect_to access_denied_path
    end
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations or /organizations.json
  def create
    if admin_signed_in?
      @organization = Organization.new(organization_params)

      respond_to do |format|
        if current_admin.present?
          @organization.admin_id = current_admin.id
          if @organization.save
            flash[:notice] = "Organização criada com sucesso."
            format.html { redirect_to projects_path }
            format.json { render :show, status: :created, location: @organization }
          else
            flash[:alert] = "Não foi possível criar organização."
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @organization.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    if admin_signed_in?
      respond_to do |format|
        if @organization.update(organization_params)
          flash[:notice] = "Organização atualizada com sucesso."
          format.html { redirect_to organization_url(@organization) }
          format.json { render :show, status: :ok, location: @organization }
        else
          flash[:alert] = "Não foi possível atualizar organização."
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @organization.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to access_denied_path
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    if admin_signed_in?
      @organization.destroy

      respond_to do |format|
        flash[:notice] = "Organização excluída com sucesso."
        format.html { redirect_to organizations_url }
        format.json { head :no_content }
      end
    else
      redirect_to access_denied_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_local_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :admin_id)
    end
end
