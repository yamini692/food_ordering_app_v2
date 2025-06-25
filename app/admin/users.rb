# app/admin/users.rb
ActiveAdmin.register User do
  permit_params :email, :role, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    actions
  end

  filter :email
  filter :created_at

  show do
    attributes_table do
      row :email
      row :role
      row :created_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :role
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
