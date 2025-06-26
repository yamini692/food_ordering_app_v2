ActiveAdmin.register Order do
  permit_params :status, :user_id, :payment_method


  scope :all, default: true
  scope("Pending")     { |orders| orders.where(status: 'pending') }
  scope("Placed")      { |orders| orders.where(status: 'placed') }
  scope("On the Way")  { |orders| orders.where(status: 'on the way') }
  scope("Delivered")   { |orders| orders.where(status: 'delivered') }
  scope("Cancelled")   { |orders| orders.where(status: 'cancelled') }

  index do
    selectable_column
    id_column
    column :user
    column :payment_method
    column :status
    column :created_at
    actions
  end

  filter :user, as: :select, collection: proc { User.all.map { |u| [u.name, u.id] } }
  filter :status, as: :select, collection: Order::STATUSES if defined?(Order::STATUSES)
  filter :payment_method, as: :select, collection: Order.pluck(:payment_method).uniq
  filter :created_at

  action_item :mark_as_delivered, only: :show do
    link_to "Mark as Delivered", mark_as_delivered_admin_order_path(order), method: :put if order.status != "delivered"
  end

  # Custom action logic
  member_action :mark_as_delivered, method: :put do
    resource.update(status: "delivered")
    redirect_to resource_path, notice: "Order marked as delivered!"
  end
end
