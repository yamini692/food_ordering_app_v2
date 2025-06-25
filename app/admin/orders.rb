# app/admin/orders.rb
ActiveAdmin.register Order do
  permit_params :status, :user_id, :payment_method

  index do
    selectable_column
    id_column
    column :user
    column :payment_method
    column :status
    column :created_at
    actions
  end

  filter :user
  filter :status
  filter :created_at
end
