# app/services/bulk_order_creator.rb
class BulkOrderCreator
  def initialize(user)
    @user = user
  end

  def call
    return [] if @user.cart_items.empty?

    orders = []

    @user.cart_items.includes(:menu_item).find_each do |cart_item|
      order = @user.orders.create(
        menu_item: cart_item.menu_item,
        quantity: 1,
        payment_method: "cash_on_delivery",
        status: "pending"
      )
      orders << order if order.persisted?
    end

    @user.cart_items.destroy_all
    orders
  end
end
