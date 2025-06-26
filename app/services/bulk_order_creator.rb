class BulkOrderCreator
  def initialize(user)
    @user = user
  end

  def call
    cart_items = @user.cart_items.includes(:menu_item)
    return nil if cart_items.empty?

    order = Order.create(user: @user, status: "pending")

    cart_items.each do |cart_item|
      OrderItem.create(order: order, menu_item: cart_item.menu_item, quantity: 1)
    end

    cart_items.destroy_all
    order
  end
end
