class ReviewsController < ApplicationController
  
  def create

    @review = Review.new(review_params)
    @review.user = current_user  # ✅ Set current user manually

    if @review.save
      redirect_back fallback_location: customer_orders_path, notice: "Review submitted!"
    else
      redirect_back fallback_location: customer_orders_path, alert: @review.errors.full_messages.to_sentence
    end
  end

  def index
    if params[:menu_item_id]
      @menu_item = MenuItem.find(params[:menu_item_id])
      @reviews = @menu_item.reviews.includes(:user)
    end
  end



  private

  def review_params
    params.require(:review).permit(:content, :rating, :user_id, :reviewable_id, :reviewable_type, :order_id)
  end

end
