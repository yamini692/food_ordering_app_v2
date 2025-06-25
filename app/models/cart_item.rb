class CartItem < ApplicationRecord
  validates :user_id, presence: true
  validates :menu_item_id, presence: true

  belongs_to :user
  belongs_to :menu_item
end
