class RestaurantOrdersController < ApplicationController
  before_action :require_restaurant
  before_action :authenticate_user!, only: [:index]  # remove :new
  def new
  end

  def book
    @order = Order.find(params[:id])
    if @order.update(status: "on the way")
      redirect_to restaurant_orders_path, notice: "Marked as 'Delivery Partner On the Way'"
    else
      redirect_to restaurant_orders_path, alert: "Failed to update status."
    end
  end
  def index
    @orders = Order
      .joins(:menu_item)
      .where(menu_items: { user_id: current_user.id })
      .where.not(status: ['delivered', 'cancelled','pending']) # 👈 filter delivered & cancelled
      .order(created_at: :desc)
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(status: "delivered")
      redirect_to restaurant_orders_path, notice: "Order marked as delivered!"
    else
      redirect_to restaurant_orders_path, alert: "Failed to update order."
    end
  end

  private

  def require_restaurant
    redirect_to root_path unless current_user&.role == "Restaurant"
  end
end
