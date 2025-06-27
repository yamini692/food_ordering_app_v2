collection @menu_items
attributes :id, :name, :price, :description, :available

child :user do
  attributes :id, :name, :email
end
