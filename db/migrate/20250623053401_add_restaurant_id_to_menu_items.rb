class AddRestaurantIdToMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_items, :restaurant_id, :integer
  end
end
