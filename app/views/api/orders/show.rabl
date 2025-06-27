object @order
attributes :id, :payment_method, :status, :quantity, :created_at

child :user do
  attributes :id, :name, :email
end
