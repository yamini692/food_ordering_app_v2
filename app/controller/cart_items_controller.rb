class CartItemsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :index, :destroy]
  def create
    current_user.cart_items.create(menu_item_id: params[:menu_item_id])
    redirect_to cart_items_path, notice: "Item added to cart!"
  end

  def index
    @cart_items = current_user.cart_items.includes(:menu_item)
  end

  def destroy
    @cart_item = current_user.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: "Item removed from cart!"
  end
end
