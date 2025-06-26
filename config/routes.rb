Rails.application.routes.draw do
  # Admin & ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # OAuth
  use_doorkeeper

  # Root
  root to: "homes#home"

  # Devise for users with custom controllers
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'  # 👈 add this to explicitly define password controller
  }

  # Explicit Devise password reset routes (optional, included by default)
  # devise_scope :user do
  #   get   'users/password/new',      to: 'users/passwords#new',     as: :new_user_password
  #   post  'users/password',          to: 'users/passwords#create',  as: :user_password
  #   get   'users/password/edit',     to: 'users/passwords#edit',    as: :edit_user_password
  #   patch 'users/password',          to: 'users/passwords#update'
  #   put   'users/password',          to: 'users/passwords#update'
  # end

  # Sign out override (if needed)
  devise_scope :user do
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end

  # Custom signup paths for roles
  devise_scope :user do
    get 'users/sign_up/customer', to: 'users/registrations#new', defaults: { role: 'Customer' }, as: :new_customer_registration
    get 'users/sign_up/restaurant', to: 'users/registrations#new', defaults: { role: 'Restaurant' }, as: :new_restaurant_registration
  end

  # Application pages
  get "menu_items/search", to: "menu_items#search", as: :search_menu_items
  get "customer/home", to: "pages#customer_home", as: :customer_home
  get "customer/menu", to: "menu_items#customer_index", as: :customer_menu
  get "customer/welcome", to: "pages#customer_welcome", as: :customer_welcome
  get "restaurant/welcome", to: "pages#restaurant_welcome", as: :restaurant_welcome
  get "restaurant/reviews", to: "restaurants#reviews", as: :restaurant_reviews
  get "customer/orders", to: "customer_orders#index", as: :customer_orders
  get "order/success", to: "orders#success", as: :order_success

  # Resources
  resources :restaurant_orders, only: [:index, :update] do
    member do
      patch :book
    end
  end

  resources :reviews, only: [:create, :edit, :update]
  resources :customer_orders, only: [:index, :destroy]
  resources :menu_items do
    get 'reviews', to: 'menu_items#reviews'
    resources :reviews, only: [:index]
  end
  resources :restaurants, only: [:show]
  resources :cart_items, only: [:index, :create, :destroy]
  resources :orders, only: [:create, :edit, :update] do
    post :book, on: :collection
    resources :reviews, only: [:edit, :update]
  end
  post "bulk_orders", to: "orders#bulk_create", as: :bulk_orders
  #resources :bulk_orders, only: [:create]
  resources :profiles
  resources :infos, only: [:new, :create, :edit, :update, :show]

  # API
  namespace :api do
    resources :customer_orders, only: [:index]
    resources :orders, only: [:create, :index, :show]
    resources :menu_items, only: [:index, :show, :create, :update, :destroy] do
      collection do
        get :top_rated
      end
    end
  end
end

