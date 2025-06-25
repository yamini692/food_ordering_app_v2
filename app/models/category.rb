class Category < ApplicationRecord
  has_and_belongs_to_many :menu_items
end
