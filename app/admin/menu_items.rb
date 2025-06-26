ActiveAdmin.register MenuItem do
  permit_params :name, :price, :description, :available, :user_id

  
  scope :all, default: true
  scope("Available")   { |items| items.where(available: true) }
  scope("Unavailable") { |items| items.where(available: false) }


  index do
    selectable_column
    id_column
    column :name
    column :price
    column :description
    column :available
    column :user
    column :created_at
    actions
  end


  filter :name
  filter :price, as: :numeric, filters: [:eq, :gt, :lt]

  filter :available, as: :select
  filter :user, as: :select, collection: proc { User.all.map { |u| [u.name, u.id] } }
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :price, min: 0.01  
      f.input :description
      f.input :available
      f.input :user
    end
    f.actions
  end
end
