class MenuItem < ApplicationRecord
  attr_accessor :raw_available

  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :order, dependent: :destroy
  has_many :orders
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :unbooked_order_items, -> { unbooked }, class_name: "OrderItem"
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, presence: true
  validate :assign_raw_available

  scope :not_deleted, -> { where(deleted_at: nil) }

  after_initialize :set_default_availability
  before_create :log_creation_details

  attr_accessor :average_rating

  def self.ransackable_associations(_auth_object = nil)
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

  def self.ransackable_attributes(_auth_object = nil)
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

  # This method handles raw_available and ensures boolean validity
  def assign_raw_available
    return if raw_available.nil?

    if raw_available == true || raw_available == false
      self.available = raw_available
    elsif raw_available.to_s.downcase.in?(%w[true false])
      self.available = raw_available.to_s.downcase == "true"
    else
      errors.add(:available, "must be true or false")
    end
  end
end
