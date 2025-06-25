class Review < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :reviewable, polymorphic: true
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
  
  def self.ransackable_attributes(auth_object = nil)
    %w[id content rating created_at updated_at user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user reviewable]
  end
end
