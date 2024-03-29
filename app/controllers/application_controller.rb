class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?

  def set_organization
    current_admin.present? ? Organization.find_by(admin_id: current_admin.id) : current_user&.organization
  end

  def has_permission?
    admin_signed_in? || current_user&.is_responsible
  end

  def access_denied
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      if current_user.is_responsible
        projects_path
      else
        users_path
      end
    elsif resource.is_a?(Admin)
      organization_already_created = Organization.exists?(admin_id: current_admin.id)

      if organization_already_created
        projects_path
      else
        new_organization_path
      end
    else
      super
    end
  end

  private

  def authenticate_user!
    unless admin_signed_in? || user_signed_in?
      redirect_to new_user_session_path, alert: "Você precisa estar logado para acessar essa página."
    end
  end
end
