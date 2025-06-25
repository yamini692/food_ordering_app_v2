class RenameCustomersIdToCustomerIdInProfiles < ActiveRecord::Migration[8.0]
  def change
    rename_column :profiles, :customers_id, :customer_id
  end
end
