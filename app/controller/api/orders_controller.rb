module Api
  class OrdersController < ActionController::API
    before_action :doorkeeper_authorize!
    before_action :set_current_user

    def index
      if doorkeeper_token.application
        @orders = Order.all
      else
        @orders = @current_user.orders
      end
      render 'api/orders/index'
    end

    def show
      @order = @current_user.orders.find_by(id: params[:id])
      if @order
        render 'api/orders/show'
      else
        render json: { error: "Order not found" }, status: :not_found
      end
    end

    def create
      @order = @current_user.orders.new(order_params)
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

    def set_current_user
      if doorkeeper_token&.resource_owner_id
        @current_user = User.find_by(id: doorkeeper_token.resource_owner_id)
      end
    end
  end
end
