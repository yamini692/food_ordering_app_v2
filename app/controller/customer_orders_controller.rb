class CustomerOrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :destroy, :destroy_all]

  def index
    @orders = current_user.orders.where(deleted_at: nil).includes(:menu_item).order(created_at: :desc)


    # Avoid nil error by ensuring @orders is initialized
    @orders ||= []

    # Group orders by user and rounded timestamp (for bulk ordering)
    @grouped_orders = @orders.group_by { |order| [order.user_id, order.created_at.to_i] }
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
    when "delivered", "cancelled", "pending"
      @order.soft_delete
      redirect_to customer_orders_path, notice: "Order history deleted."
    else
      redirect_to customer_orders_path, alert: "This order cannot be deleted."
    end
  end

  def destroy_all
    # You can use soft_delete instead of destroy_all if needed
    current_user.orders.each do |order|
      if order.status.in?(%w[delivered cancelled pending])
        order.soft_delete
      else
        order.destroy  # use destroy or update status if needed
      end
    end

    redirect_to customer_orders_path, notice: "🗑️ All your orders have been deleted."
  end
end
