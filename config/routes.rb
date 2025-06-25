Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  use_doorkeeper
  # config/routes.rb


  root to: "homes#home"
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions'
}
devise_scope :user do
  get 'users/sign_out', to: 'devise/sessions#destroy'
end


  # Custom registration routes
   devise_scope :user do
    get 'users/sign_up/customer', to: 'users/registrations#new', defaults: { role: 'Customer' }, as: :new_customer_registration
    get 'users/sign_up/restaurant', to: 'users/registrations#new', defaults: { role: 'Restaurant' }, as: :new_restaurant_registration
  end




  # as :user do
  #   get    'login',  to: 'sessions#new',     as: :new_user_session
  #   post   'login',  to: 'sessions#create',  as: :user_session
  #   delete 'logout', to: 'sessions#destroy', as: :destroy_user_session
  # end
  get "menu_items/search", to: "menu_items#search", as: :search_menu_items
  get "customer/home", to: "pages#customer_home", as: :customer_home
  get "customer/menu", to: "menu_items#customer_index", as: :customer_menu
  
  resources :restaurant_orders, only: [:index, :update] do
    member do
      patch :book  # for "Book (On the Way)"
    end
  end
  

  #get "restaurant/orders", to: "restaurant_orders#index", as: :restaurant_orders
  


  get "customer/welcome", to: "pages#customer_welcome", as: :customer_welcome
  get "restaurant/welcome", to: "pages#restaurant_welcome", as: :restaurant_welcome
  #patch "restaurant/orders/:id/book", to: "restaurant_orders#book", as: :book_order
  get "restaurant/reviews", to: "restaurants#reviews", as: :restaurant_reviews


  get "customer/orders", to: "customer_orders#index", as: :customer_orders
  resources :reviews, only: [:create]
  resources :customer_orders, only: [:index, :destroy]
  resources :reviews, only: [:create, :edit, :update]

  resources :menu_items do
    get 'reviews', to: 'menu_items#reviews'
  end
  resources :restaurants, only: [:show]
  post "bulk_orders", to: "orders#bulk_create", as: :bulk_orders
  resources :menu_items
  resources :cart_items, only: [ :index, :create, :destroy ]
  resources :orders, only: [:create, :edit, :update] do
    post :book, on: :collection
  end

  get "order/success", to: "orders#success", as: :order_success
  resources :menu_items do
    resources :reviews, only: [:index]
  end
  resources :profiles
  resources :infos, only: [:new, :create, :edit, :update, :show]
  resources :orders do
  resources :reviews, only: [:edit, :update]
end
  namespace :api do
    resources :customer_orders, only: [:index]
  end
 
  namespace :api do
    resources :orders, only: [:create]
  end
  namespace :api do
    resources :menu_items, only: [:index, :show, :create, :update, :destroy] do
      collection do
        get :top_rated
      end
    end
  end



  #get "/api/customer_orders", to: "customer_orders#api_index"





  
end
