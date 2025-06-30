class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new_customer
    build_resource({})
    resource.role = "Customer"
    respond_with resource
  end

  def new_restaurant
    build_resource({})
    resource.role = "Restaurant"
    respond_with resource
  end

  def create
    super do |resource|
      if resource.persisted?
        # Redirect after sign up (instead of auto-login)
        sign_out(resource)
        redirect_to new_user_session_path and return
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
  end
end
