class AddCustomerDeletedToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :customer_deleted, :boolean
  end
end
