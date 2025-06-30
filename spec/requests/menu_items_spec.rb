require 'rails_helper'

RSpec.describe "API::MenuItems", type: :request do
  let(:user) { create(:user, :restaurant) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }
  let(:headers) { { "Authorization" => "Bearer #{token.token}" } }

  describe "POST /api/menu_items" do
    subject { post "/api/menu_items", params: params, headers: headers }

    context "with valid params" do
      let(:params) do
        {
          menu_item: {
            name: "Pizza",
            price: 250,
            description: "Cheesy goodness",
            available: true
          }
        }
      end

      it "returns 201 Created" do
        subject
        expect(response).to have_http_status(:created)
      end
    end

    context "with missing params" do
      let(:params) { { menu_item: { name: "", price: nil } } }

      it "returns 422 Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "includes errors in response" do
        subject
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end

    context "with price <= 0" do
      let(:params) { { menu_item: { name: "Burger", price: 0 } } }

      it "returns 422 Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "includes price error" do
        subject
        expect(JSON.parse(response.body)["errors"]).to include("Price must be greater than 0")
      end
    end

    context "without authentication" do
      it "returns 401 Unauthorized" do
        post "/api/menu_items", params: { menu_item: { name: "Pizza", price: 250 } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      it "returns 401 Unauthorized" do
        post "/api/menu_items", params: { menu_item: { name: "Pizza", price: 250 } },
             headers: { "Authorization" => "Bearer invalid_token" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with unauthorized role" do
      let(:customer) { create(:user, :customer) }
      let(:customer_token) { create(:access_token, resource_owner_id: customer.id) }

      it "returns 403 Forbidden" do
        post "/api/menu_items", params: { menu_item: { name: "Pizza", price: 250 } },
             headers: { "Authorization" => "Bearer #{customer_token.token}" }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /api/menu_items/:id" do
    let(:menu_item) { create(:menu_item, user: user) }
    let(:menu_item_id) { menu_item.id }
    subject { get "/api/menu_items/#{menu_item_id}", headers: headers }

    context "when item exists" do
      it "returns 200 OK" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "when item does not exist" do
      let(:menu_item_id) { 999999 }

      it "returns 404 Not Found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context "without token" do
      it "returns 401 Unauthorized" do
        get "/api/menu_items/#{menu_item.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      it "returns 401 Unauthorized" do
        get "/api/menu_items/#{menu_item.id}", headers: { "Authorization" => "Bearer invalid_token" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/menu_items/:id" do
    let(:menu_item) { create(:menu_item, user: user) }
    let(:params) { { menu_item: { name: "Updated Pizza" } } }

    subject { patch "/api/menu_items/#{menu_item.id}", params: params, headers: headers }

    it "updates and returns 200 OK" do
      subject
      expect(response).to have_http_status(:ok)
    end

    context "with invalid update" do
      let(:params) { { menu_item: { price: 0 } } }

      it "returns 422 Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "without token" do
      it "returns 401 Unauthorized" do
        patch "/api/menu_items/#{menu_item.id}", params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      it "returns 401 Unauthorized" do
        patch "/api/menu_items/#{menu_item.id}", params: params,
              headers: { "Authorization" => "Bearer invalid" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/menu_items/:id" do
    let(:menu_item) { create(:menu_item, user: user) }

    subject { delete "/api/menu_items/#{menu_item.id}", headers: headers }

    it "soft deletes and returns 200 OK" do
      subject
      expect(response).to have_http_status(:ok)
    end

    context "delete fails" do
      before { allow_any_instance_of(MenuItem).to receive(:soft_delete).and_raise("Unexpected error") }

      it "returns 422 Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "without token" do
      it "returns 401 Unauthorized" do
        delete "/api/menu_items/#{menu_item.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      it "returns 401 Unauthorized" do
        delete "/api/menu_items/#{menu_item.id}", headers: { "Authorization" => "Bearer fake" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/menu_items/top_rated" do
    subject { get "/api/menu_items/top_rated", headers: headers }

    before { create(:menu_item, user: user) }

    it "returns 200 OK" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "returns 401 without token" do
      get "/api/menu_items/top_rated"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with invalid token" do
      get "/api/menu_items/top_rated", headers: { "Authorization" => "Bearer invalid" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/menu_items" do
    before { create_list(:menu_item, 3, user: user) }

    subject { get "/api/menu_items", headers: headers }

    it "returns all items with 200" do
      subject
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to be >= 3
    end

    it "returns 401 without token" do
      get "/api/menu_items"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with invalid token" do
      get "/api/menu_items", headers: { "Authorization" => "Bearer wrong" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
