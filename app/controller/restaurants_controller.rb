class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: [:show]  # Remove :new

  def show
    @reviews = Review.where(reviewable: current_user)

  end
  def reviews
    @restaurant_reviews = Review.where(reviewable_type: "Restaurant", reviewable_id: current_user.id)
    @menu_reviews = Review.where(reviewable_type: "MenuItem")
    @order_reviews = Review.where(reviewable_type: "Order")
  end
end
