class CustomerOrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def index
    @orders = current_user.orders.includes(:menu_item).not_deleted
  end
  def destroy
    @order = current_user.orders.find_by(id: params[:id])

    if @order.nil? || @order.deleted?
      redirect_to customer_orders_path, alert: "Order not found or already deleted."
      return
    end

    case @order.status
    when "placed"
      @order.update(status: "cancelled")
      redirect_to customer_orders_path, notice: "Order was cancelled."
    when "delivered"
      @order.soft_delete
      redirect_to customer_orders_path, notice: "Order history deleted."
    when "cancelled"
      @order.soft_delete
      redirect_to customer_orders_path, notice: "Order history deleted."
    when "pending"
      @order.soft_delete
      redirect_to customer_orders_path, notice: "Order history deleted."
    else
      redirect_to customer_orders_path, alert: "This order cannot be deleted."
    end
  end



end
