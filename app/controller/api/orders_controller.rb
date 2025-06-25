# app/controllers/api/orders_controller.rb
module Api
  class OrdersController < ActionController::API
    before_action :doorkeeper_authorize!  # Auth required
    before_action :current_user

    def create
      @order = current_user.orders.new(order_params)
      if @order.save
        render json: { message: "Order placed successfully", order: @order }, status: :created
      else
        render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
      end
    end


    private

    def order_params
      params.require(:order).permit(:payment_method, :menu_item_id, :quantity, :status)
    end


    def current_user
      @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
    end
  end
end
