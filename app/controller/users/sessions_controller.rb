# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
  end
  def create
    email = params[:user][:email]
    password = params[:user][:password]
    user = User.find_by(email: email)

    if user && user.valid_password?(password)
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
  redirect_to new_user_session_path, notice: "Logged out!"
end
  
end
