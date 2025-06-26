require 'rails_helper'

RSpec.describe "API::CustomerOrders", type: :request do
  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }

  describe "GET /api/customer_orders" do
    it "returns the user's orders" do
      create_list(:order, 2, user: user)
      get "/api/customer_orders", headers: { Authorization: "Bearer #{token.token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end
end
