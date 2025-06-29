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
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end

    context "with price <= 0" do
      let(:params) do
        {
          menu_item: {
            name: "Burger",
            price: 0,
            description: "Invalid price",
            available: true
          }
        }
      end

      it "returns 422 Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Price must be greater than 0")
      end
    end

    context "without authentication" do
      subject { post "/api/menu_items", params: { menu_item: { name: "Pizza", price: 250 } } }

      it "returns 401 Unauthorized" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid role" do
      let(:restricted_user) { create(:user, :customer) }
      let(:restricted_token) { create(:access_token, resource_owner_id: restricted_user.id) }
      let(:headers) { { "Authorization" => "Bearer #{restricted_token.token}" } }
      let(:params) { { menu_item: { name: "Pizza", price: 250 } } }

      subject { post "/api/menu_items", params: params, headers: headers }

      it "returns 403 Forbidden" do
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /api/menu_items/:id" do
    let(:menu_item) { create(:menu_item, user: user) }

    subject { get "/api/menu_items/#{menu_item_id}", headers: headers }

    context "when menu item exists" do
      let(:menu_item_id) { menu_item.id }

      it "returns 200 OK" do
        subject
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(menu_item.id)
      end
    end

    context "when menu item does not exist" do
      let(:menu_item_id) { 999999 }

      it "returns 404 Not Found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /api/menu_items/:id" do
    let(:menu_item) { create(:menu_item, user: user) }
    let(:menu_item_id) { menu_item.id }
    let(:params) { { menu_item: update_params } }

    subject { patch "/api/menu_items/#{menu_item_id}", params: params, headers: headers }

    context "with valid update" do
      let(:update_params) { { name: "Updated Pizza" } }

      it "returns 200 OK" do
        subject
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq("Updated Pizza")
      end
    end

    context "with invalid update" do
      let(:update_params) { { price: 0 } }

      it "returns 422 Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Price must be greater than 0")
      end
    end
  end

  describe "DELETE /api/menu_items/:id" do
    let(:menu_item) { create(:menu_item, user: user) }
    let(:menu_item_id) { menu_item.id }

    subject { delete "/api/menu_items/#{menu_item_id}", headers: headers }

    it "soft deletes and returns 200 OK" do
      subject
      expect(response).to have_http_status(:ok)
    end

    context "when delete fails" do
      before do
        allow_any_instance_of(MenuItem).to receive(:soft_delete).and_raise("Unexpected error")
      end

      it "returns 422 Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Unexpected error")
      end
    end
  end

  describe "GET /api/menu_items/top_rated" do
    subject { get "/api/menu_items/top_rated", headers: headers }

    it "returns 200 OK with top-rated items" do
      create(:menu_item, user: user)
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/menu_items/:id with invalid token user" do
    let(:invalid_token) { create(:access_token, resource_owner_id: 99999) }

    subject do
      get "/api/menu_items/1", headers: { "Authorization" => "Bearer #{invalid_token.token}" }
    end

    it "returns 401 Unauthorized" do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/menu_items" do
    subject { get "/api/menu_items", headers: headers }

    before { create_list(:menu_item, 2, user: user) }

    it "returns 200 OK with list" do
      subject
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to be >= 2
    end
  end
end
