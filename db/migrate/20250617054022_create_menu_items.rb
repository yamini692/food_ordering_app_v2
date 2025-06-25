class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.decimal :price
      t.boolean :available
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
