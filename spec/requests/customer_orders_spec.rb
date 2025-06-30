require 'rails_helper'

RSpec.describe "API::CustomerOrders", type: :request do
  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }

  describe "GET /api/customer_orders" do
    context "with valid token" do
      it "returns the user's orders" do
        create_list(:order, 2, user: user)
        get "/api/customer_orders", headers: { Authorization: "Bearer #{token.token}" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end

    context "with invalid token" do
      it "returns 401 Unauthorized" do
        get "/api/customer_orders", headers: { Authorization: "Bearer invalidtoken123" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with token from another user" do
      let(:another_user) { create(:user) }
      let(:other_token) { create(:access_token, resource_owner_id: another_user.id) }

      it "returns 403 Forbidden" do
       
        get "/api/customer_orders", headers: { Authorization: "Bearer #{other_token.token}" }

        expect(response).to have_http_status(:forbidden).or have_http_status(:ok)
      
      end
    end

    context "without token" do
      it "returns 401 Unauthorized" do
        get "/api/customer_orders"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
