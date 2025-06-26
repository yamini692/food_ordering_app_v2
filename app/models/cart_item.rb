class CartItem < ApplicationRecord
  include RansackableDefinitions

  validates :user, presence: true
  validates :menu_item, presence: true

  belongs_to :user
  belongs_to :menu_item

end
