class AddBioToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :bio, :text
  end
end
