class MenuItemsController < ApplicationController
  before_action :require_customer, only: [:search]
  before_action :authenticate_user!, only: [:create, :index, :destroy]
  
  def index
    @menu_items = current_user.menu_items
  end

  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = current_user.menu_items.build(menu_item_params)

    if @menu_item.save
      redirect_to menu_items_path, notice: "Menu item created successfully."
    else
      render :new
    end
  end


  def show
    if current_user.is_a?(Restaurant)
      @menu_item = current_user.menu_items.find(params[:id])
    else
      @menu_item = MenuItem.find(params[:id])
    end
  end


  def destroy
    @menu_item = MenuItem.find(params[:id])
    @menu_item.orders.each do |order|
      order.review.destroy if order.review.present?
    end
    @menu_item.destroy
  end
  def edit
    @menu_item = MenuItem.find(params[:id])
  end


  def update
    @menu_item = MenuItem.find(params[:id])
    if @menu_item.update(menu_item_params)
      redirect_to menu_items_path, notice: "Menu updated!"
    else
      render :edit
    end
  end
  def search
    @categories = Category.all

    @menu_items = MenuItem.includes(:categories)

    if params[:query].present?
      @menu_items = @menu_items.where("menu_items.name ILIKE ?", "%#{params[:query]}%")
    end

    if params[:available].present?
      @menu_items = @menu_items.where(available: params[:available])
    end

    if params[:category_id].present?
      @menu_items = @menu_items.joins(:categories).where(categories: { id: params[:category_id] })
    end
  end

  def customer_index
  end
  def reviews
    @menu_item = MenuItem.find(params[:menu_item_id])
    @reviews = @menu_item.reviews.includes(:user)
  end



  private

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :description, :available, category_ids: [])
  end

  def require_restaurant
    redirect_to root_path unless current_user.is_a?(Restaurant)
  end


  def require_customer
    redirect_to login_path unless current_user&.customer?
  end
end
