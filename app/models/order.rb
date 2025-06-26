class Order < ApplicationRecord
  include RansackableDefinitions
  STATUSES = ['pending', 'placed', 'on the way', 'delivered', 'cancelled']


  # app/models/order.rb
  validates :payment_method, presence: true, unless: -> { status == "pending" }

  validates :payment_method, presence: true
  validates :status, inclusion: { in: STATUSES }


  belongs_to :user
  belongs_to :menu_item
  has_many :order_items, dependent: :destroy
  has_one :review, dependent: :destroy

  scope :not_deleted, -> { where(deleted_at: nil) }

  scope :unbooked_for_restaurant, ->(restaurant_id) {
    joins(:menu_item, :order_items)
      .where(
        menu_items: { user_id: restaurant_id },
        orders: { status: ["placed"] },
        order_items: { booked: [false, nil] }
      ).distinct
  }

  

  after_initialize :set_default_status

  def soft_delete
    update(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end
end
