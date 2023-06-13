class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

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
      organization_already_created = Organization.where(admin_id: current_admin.id).exists?

      if organization_already_created
        projects_path
      else
        new_organization_path
      end
    else
      super
    end
  end
end
