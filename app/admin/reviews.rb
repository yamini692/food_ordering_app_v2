ActiveAdmin.register Review do
  permit_params :rating, :content, :user_id, :reviewable_type, :reviewable_id

  scope :all, default: true
  scope("1 Star")      { |reviews| reviews.where(rating: 1) }
  scope("2 Stars")     { |reviews| reviews.where(rating: 2) }
  scope("3 Stars")     { |reviews| reviews.where(rating: 3) }
  scope("4 Stars")     { |reviews| reviews.where(rating: 4) }
  scope("5 Stars")     { |reviews| reviews.where(rating: 5) }
  scope("Order Reviews")     { |r| r.where(reviewable_type: "Order") }
  scope("MenuItem Reviews")  { |r| r.where(reviewable_type: "MenuItem") }


  index do
    selectable_column
    id_column
    column :user
    column :reviewable_type
    column :reviewable_id
    column :rating
    column :content
    column :created_at
    actions
  end

  # === SAFE FILTERS ===
  filter :user
  filter :rating, as: :select, collection: 1..5
  filter :created_at
end
