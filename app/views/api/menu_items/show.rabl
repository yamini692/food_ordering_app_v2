object @menu_item
attributes :id, :name, :price, :description, :available, :created_at

child :user do
  attributes :id, :name, :email
end
