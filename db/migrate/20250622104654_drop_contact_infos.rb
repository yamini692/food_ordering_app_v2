class DropContactInfos < ActiveRecord::Migration[8.0]
  def change
    drop_table :contact_infos
  end
end
