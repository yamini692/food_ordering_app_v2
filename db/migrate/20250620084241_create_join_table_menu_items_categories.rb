class CreateJoinTableMenuItemsCategories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :menu_items, :categories do |t|
      t.index :menu_item_id
      t.index :category_id
    end
  end
end
