module RansackableDefinitions
  MODEL_RANSACKABLE_ATTRIBUTES = {
    'User' => %w[id name email role created_at updated_at],
    'Order' => %w[id user_id status payment_method created_at updated_at],
    'Review' => %w[id content rating created_at updated_at user_id],
    'CartItem' => %w[id quantity user_id menu_item_id created_at updated_at]
  }.freeze

  MODEL_RANSACKABLE_ASSOCIATIONS = {
    'User' => %w[user order_items menu_items],
    'Order' => %w[user menu_item],
    'Review' => %w[user reviewable],
    'MenuItem' => [],
    'CartItem' => []
  }.freeze

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def ransackable_attributes(auth_object = nil)
      MODEL_RANSACKABLE_ATTRIBUTES[self.name] || []
    end

    def ransackable_associations(auth_object = nil)
      MODEL_RANSACKABLE_ASSOCIATIONS[self.name] || []
    end
  end
end
