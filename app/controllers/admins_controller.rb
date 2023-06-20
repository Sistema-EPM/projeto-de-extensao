class AdminsController < ApplicationController
  before_action :set_admin, only: %i[ show edit update destroy ]

  # GET /admins or /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        flash[:notice] = "Admin criado com sucesso."
        format.html { redirect_to admin_url(@admin) }
        format.json { render :show, status: :created, location: @admin }
      else
        flash[:alert] = "Não foi possível criar admin."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        flash[:notice] = "Admin atualizado com sucesso."
        format.html { redirect_to admin_url(@admin) }
        format.json { render :show, status: :ok, location: @admin }
      else
        flash[:alert] = "Não foi possível atualizar admin."
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy

    respond_to do |format|
      flash[:notice] = "Admin excluído com sucesso."
      format.html { redirect_to admins_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(current_admin.id)
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:name, :email, :password)
    end
end
