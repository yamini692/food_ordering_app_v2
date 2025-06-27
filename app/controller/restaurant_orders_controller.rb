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
  

    # Group orders by user and status
    def index
      orders = Order.joins(:menu_item)
                    .where(menu_items: { user_id: current_user.id })
                    .where(status: ["pending", "placed", "on the way"])
                    .where(deleted_at: nil)
                    .includes(:menu_item, :user)
                    .order(:created_at)

      # Group only those orders with same user and same created_at timestamp (bulk)
      @grouped_orders = orders.group_by { |order| [order.user_id, order.created_at.to_i] }
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
