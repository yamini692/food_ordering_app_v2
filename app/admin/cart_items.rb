ActiveAdmin.register CartItem do
  permit_params :user_id, :menu_item_id, :quantity

  index do
    selectable_column
    id_column
    column :user
    column :menu_item
    column :quantity
    column :created_at
    actions
  end

  filter :user
  filter :menu_item
  filter :quantity
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user
      f.input :menu_item
      f.input :quantity
    end
    f.actions
  end
end
