class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      redirect_to customer_home_path, notice: "Profile created successfully!"
    else
      render :new
    end
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      redirect_to customer_home_path, notice: "Profile updated!"
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:phone, :address, :bio)
  end
end