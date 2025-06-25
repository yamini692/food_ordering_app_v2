class CreateContactInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_infos do |t|
      t.string :address
      t.string :phone
      t.text :bio
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
