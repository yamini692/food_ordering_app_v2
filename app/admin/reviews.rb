# app/admin/reviews.rb
ActiveAdmin.register Review do
  permit_params :rating, :content, :user_id, :reviewable_type, :reviewable_id

  index do
    selectable_column
    id_column
    column :user
    column :reviewable
    column :rating
    column :content
    column :created_at
    actions
  end

  filter :user
  filter :rating
  filter :created_at
end
