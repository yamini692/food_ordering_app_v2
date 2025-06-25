class InfosController < ApplicationController
  before_action :set_info, only: [:edit, :update, :show]

  def new
    @info = current_user.build_info
  end

  def create
    @info = current_user.build_info(info_params)  # This sets user_id correctly

    if @info.save
      redirect_to customer_home_path, notice: "Info added successfully."
    else
      render :new
    end
  end


  def edit
  end

  def update
    if @info.update(info_params)
      redirect_to @info, notice: 'Info updated successfully.'
    else
      render :edit
    end
  end

  def show
  end

  private

  def set_info
    @info = current_user.info
  end

  def info_params
    params.require(:info).permit(:address, :phone, :bio)
  end
end
