class User < ApplicationRecord
  include RansackableDefinitions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :role, inclusion: { in: ["Customer", "Restaurant"] }


  has_many :cart_items
  has_many :orders
  has_many :menu_items, foreign_key: "user_id"
  has_many :received_orders, through: :menu_items, source: :orders
  has_many :reviews, dependent: :destroy
  has_one :info, dependent: :destroy

  accepts_nested_attributes_for :info

 
  before_validation :strip_email
  before_save :downcase_email

  def customer?
    role == "Customer"
  end

  def restaurant?
    role == "Restaurant"
  end

  private

  def strip_email
    self.email = email.strip if email.present?
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
