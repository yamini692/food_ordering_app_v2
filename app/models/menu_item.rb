class MenuItem < ApplicationRecord
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :available, inclusion: { in: [true, false] }
  validates :description, presence: true

  
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :order, dependent: :destroy
  has_many :orders
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :unbooked_order_items, -> { unbooked }, class_name: "OrderItem"
  has_and_belongs_to_many :categories

 
  scope :not_deleted, -> { where(deleted_at: nil) }

  attr_accessor :average_rating

  after_initialize :set_default_availability
  before_create :log_creation_details

  def self.ransackable_associations(auth_object = nil)
    %w[
      cart_items
      categories
      order
      order_items
      orders
      reviews
      unbooked_order_items
      user
    ]
  end

  def self.ransackable_attributes(auth_object = nil)
    column_names
  end

 
  def soft_delete
    update(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end

  private


  def set_default_availability
    self.available = false if available.nil?
  end

  def log_creation_details
    Rails.logger.info "Creating MenuItem: #{self.name}, price: #{self.price}"
  end
end
