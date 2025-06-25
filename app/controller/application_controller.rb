class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :admin_namespace?

  def require_customer
    unless current_user&.role == "Customer"
      redirect_to new_user_session_path, alert: "You must be logged in as a customer"
    end
  end

  def require_restaurant
    unless current_user&.role == "Restaurant"
      redirect_to new_user_session_path, alert: "You must be logged in as a restaurant"
    end
  end

  private

  # Skip Devise login requirement only for ActiveAdmin paths
  def admin_namespace?
    request.fullpath.start_with?("/admin")
  end
end
