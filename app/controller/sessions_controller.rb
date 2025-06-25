class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  def new
  end
  def create
    user = User.find_by(email: params[:email])

    if user && user.valid_password?(params[:password])
      sign_in(user)  

      if user.role == "Restaurant"
        redirect_to restaurant_welcome_path
      elsif user.role == "Customer"
        redirect_to customer_home_path
      else
        redirect_to root_path, alert: "Unknown user type"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end


def destroy
  sign_out(current_user)
  redirect_to login_path, notice: "Logged out!"
end
  
end
