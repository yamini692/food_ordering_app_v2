class Restaurant < User
  has_many :menu_items, foreign_key: "user_id"
  has_many :reviews, as: :reviewable, dependent: :destroy
end
