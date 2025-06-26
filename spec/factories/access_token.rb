# spec/factories/access_token.rb
FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    application { create(:oauth_application) }
    resource_owner_id { create(:user).id }
    scopes { 'public' }
  end
end
