collection @orders
attributes :id, :payment_method, :status, :created_at

child :user do
  attributes :id, :name, :email
end
