class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_customer, only: [:customer_home]

  def customer_home
    @categories = Category.all
    @menu_items = MenuItem.includes(:categories).where(available: true)

    if params[:query].present?
      @menu_items = @menu_items.where("menu_items.name ILIKE ?", "%#{params[:query]}%")
    end

    if params[:category_id].present?
      @menu_items = @menu_items.joins(:categories).where(categories: { id: params[:category_id] })
    end
  end

  def customer_welcome; end
  def restaurant_welcome; end
end
