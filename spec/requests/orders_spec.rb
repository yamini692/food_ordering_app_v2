require 'rails_helper'

RSpec.describe "API::Orders", type: :request do
  let(:user) { create(:user) }
  let(:menu_item) { create(:menu_item, user: user) } 
  let(:token) { create(:access_token, resource_owner_id: user.id) }

  describe "POST /api/orders" do
    it "creates an order" do
      post "/api/orders",
        params: {
          order: {
            payment_method: "Card",
            menu_item_id: menu_item.id,
            quantity: 2,
            status: "placed"
          }
        },
        headers: { Authorization: "Bearer #{token.token}" }

      puts response.body
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["message"]).to eq("Order placed successfully")
    end
  end
end
