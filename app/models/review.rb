class Review < ApplicationRecord
  include RansackableDefinitions
  belongs_to :user
  belongs_to :order
  belongs_to :reviewable, polymorphic: true
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
  
end
