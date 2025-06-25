class AddBookedToOrderItems < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :booked, :boolean
  end
end
