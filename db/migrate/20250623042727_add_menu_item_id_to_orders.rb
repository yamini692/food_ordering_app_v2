class AddMenuItemIdToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :menu_item,foreign_key: true
  end
end
