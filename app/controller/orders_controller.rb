class OrdersController < ApplicationController
  # orders_controller.rb
  before_action :authenticate_user!, only: [:create, :book]
  def create
    if current_user&.persisted?
      menu_item = MenuItem.find(params[:menu_item_id])

      @order = current_user.orders.new(
        menu_item: menu_item,
        payment_method: "cash_on_delivery",  # adjust this as needed
        status: "pending"                    # match this to allowed statuses
      )

      if @order.save
        redirect_to edit_order_path(@order), notice: "Order created. Please complete payment."
      else
        Rails.logger.error("Order save failed: #{@order.errors.full_messages.join(', ')}")
        redirect_to customer_home_path, alert: "Order failed: #{@order.errors.full_messages.join(', ')}"
      end
    else
      redirect_to menu_items_path, alert: "User is not logged in or not saved."
    end
  end
  def book
      puts "=== BOOK action called ==="
      puts "Params: #{params.inspect}"

      menu_item = MenuItem.find(params[:menu_item_id])
      puts "MenuItem found: #{menu_item.id}"

      @order = current_user.orders.new(
        menu_item: menu_item,
        payment_method: "cash_on_delivery",
        status: "pending"
      )

      if @order.save
        puts "Order saved successfully: #{@order.id}"
        redirect_to edit_order_path(@order), notice: "Order created. Please complete payment."
      else
        puts "Order save failed: #{@order.errors.full_messages.join(', ')}"
        redirect_to customer_home_path, alert: "Order failed: #{@order.errors.full_messages.join(', ')}"
      end
  end



  def edit
    @order = current_user.orders.find(params[:id])
  end

  def update
    @order = current_user.orders.find(params[:id])
    @order.update(order_params.merge(status: "placed"))
    redirect_to order_success_path
  end


  def success
  end
  def bulk_create
    order = BulkOrderCreator.new(current_user).call

    if order
      redirect_to edit_order_path(order), notice: "Please choose a payment method to confirm your order."
    else
      redirect_to cart_items_path, alert: "Your cart is empty!"
    end
  end



  private

  def order_params
    params.require(:order).permit(:quantity, :payment_method)
  end

end