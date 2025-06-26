module Api
  class OrdersController < ActionController::API
    before_action :doorkeeper_authorize!
    before_action :current_user
    def index
      if doorkeeper_token.application
      # Access by client credentials (admin-level)
      @orders = Order.all
        render json: @orders
      elsif current_user
        @orders = current_user.orders
        render 'api/orders/index'
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def show
      @order = current_user.orders.find_by(id: params[:id])
      if @order
        render json: @order
      else
        render json: { error: "Order not found" }, status: :not_found
      end
    end

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
      return nil unless doorkeeper_token

      if doorkeeper_token.resource_owner_id
        @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
      else
        nil
      end
    end

  end
end
