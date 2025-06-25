module Api
  class CustomerOrdersController < ActionController::API
    before_action :doorkeeper_authorize!

    def index
      user = User.find(doorkeeper_token.resource_owner_id)
      orders = user.orders.includes(:menu_item)

      render json: orders
    end
  end
end
