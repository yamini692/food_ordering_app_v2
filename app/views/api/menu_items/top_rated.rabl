collection @top_items
attributes :id, :name, :price, :description, :available

node(:average_rating) { |item| item.try(:average_rating).to_f.round(2) }

child :user do
  attributes :id, :name
end
