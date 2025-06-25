module Api
  class MenuItemsController < Api::ApplicationController
    before_action :doorkeeper_authorize!
    before_action :set_current_user
    before_action :authorize_restaurant!, except: [:index, :show, :top_rated]
    before_action :set_menu_item, only: [:show, :update, :destroy]

    # GET /api/menu_items
    def index
      menu_items = MenuItem.all
      render json: menu_items, status: :ok
    end

    # GET /api/menu_items/:id
    def show
      render json: @menu_item, status: :ok
    end

    # POST /api/menu_items
    def create
      menu_item = @current_user.menu_items.build(menu_item_params)
      if menu_item.save
        render json: menu_item, status: :created
      else
        render json: { errors: menu_item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PUT/PATCH /api/menu_items/:id
    def update
      if @menu_item.update(menu_item_params)
        render json: @menu_item, status: :ok
      else
        render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/menu_items/:id
    def destroy
      @menu_item.soft_delete if @menu_item.respond_to?(:soft_delete)
      render json: { message: "Menu item soft deleted" }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    # GET /api/menu_items/top_rated
    def top_rated
      top_items = MenuItem
                    .joins(:reviews)
                    .select('menu_items.*, AVG(reviews.rating) AS average_rating')
                    .group('menu_items.id')
                    .order('average_rating DESC')
                    .limit(5)

      render json: top_items.as_json(methods: :average_rating), status: :ok
    end

    private

    def set_current_user
      @current_user = User.find(doorkeeper_token[:resource_owner_id])
    rescue ActiveRecord::RecordNotFound
      unauthorized
    end

    def authorize_restaurant!
      unless @current_user&.role == "Restaurant"
        forbidden
      end
    end

    def set_menu_item
      @menu_item = @current_user.menu_items.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      not_found(ActiveRecord::RecordNotFound.new("MenuItem not found or not accessible."))
    end

    def menu_item_params
      params.require(:menu_item).permit(:name, :price, :description, :available, category_ids: [])
    end
  end
end
