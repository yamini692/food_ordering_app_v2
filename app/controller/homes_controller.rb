class HomesController < ApplicationController
  before_action :authenticate_user!

  def home
    if current_user.role == "Restaurant"
      redirect_to restaurant_welcome_path
    elsif current_user.role == "Customer"
      redirect_to customer_home_path
    else
      render plain: "Unknown role"
    end
  end
end
