class AddDeletedAtToMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_items, :deleted_at, :datetime
  end
end
