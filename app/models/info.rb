class Info < ApplicationRecord
  belongs_to :user
  validates :address, presence: true
  validates :phone, presence: true, length: { is: 10 }
  validates :bio, presence: true
end
