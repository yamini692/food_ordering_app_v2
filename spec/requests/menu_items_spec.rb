# spec/requests/menu_items_spec.rb

require 'rails_helper'

RSpec.describe "API::MenuItems", type: :request do
  describe "POST /api/menu_items" do
    let(:user) { create(:user, :restaurant) }  # ✅ Trait-based role
    let(:token) { create(:access_token, resource_owner_id: user.id) }
    let(:headers) { { "Authorization" => "Bearer #{token.token}" } }

    context "with valid params" do
      it "creates a menu item and returns 201" do
        post "/api/menu_items",
             params: {
               menu_item: {
                 name: "Pizza",
                 price: 250,
                 description: "Cheesy goodness",
                 available: true
               }
             },
             headers: headers

        puts response.body # 🔍 Optional debug
        expect(response).to have_http_status(:created)
      end
    end

    context "with missing params" do
      it "returns 422 Unprocessable Entity" do
        post "/api/menu_items",
             params: {
               menu_item: {
                 name: "", price: nil
               }
             },
             headers: headers

        puts response.body
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "without authentication" do
      it "returns 401 Unauthorized" do
        post "/api/menu_items",
             params: {
               menu_item: {
                 name: "Pizza", price: 250
               }
             }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid role or access" do
      it "returns 403 Forbidden" do
        restricted_user = create(:user, :customer)
        restricted_token = create(:access_token, resource_owner_id: restricted_user.id)

        post "/api/menu_items",
             params: {
               menu_item: {
                 name: "Pizza", price: 250
               }
             },
             headers: { "Authorization" => "Bearer #{restricted_token.token}" }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
