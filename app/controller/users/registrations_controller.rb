class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_if_authenticated, only: [:new]

  def new_customer
    build_resource({})
    resource.role = 'Customer'
    respond_with resource, location: after_sign_up_path_for(resource)
  end

  def new_restaurant
    build_resource({})
    resource.role = 'Restaurant'
    respond_with resource, location: after_sign_up_path_for(resource)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone])
  end

  def after_sign_up_path_for(resource)
    case resource.role
    when "Restaurant"
      restaurant_welcome_path
    when "Customer"
      customer_home_path
    else
      root_path
    end
  end

  private

  def redirect_if_authenticated
    if user_signed_in?
      redirect_to authenticated_root_path, alert: "You are already signed in."
    end
  end
end
