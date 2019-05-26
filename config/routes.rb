Rails.application.routes.draw do
  devise_for :users, skip: %i(sessions registrations passwords)
  root "static_pages#home"

  devise_scope :user do
    get "sign_in", to: "users/sessions#new", as: "new_user_session"
    get "registration", to: "users/registrations#new", as: "new_user_registration"
    # get "profile", to: "users/accounts#show"
    get "changepassword", to: "users/registrations#edit", as: "edit_user_registration"
    get "resetpassword", to: "users/passwords#new", as: "new_user_password"
    get "resetpassword/edit", to: "users/passwords#edit", as: "edit_user_password"

    post "registration", to: "users/registrations#create", as: "user_registration"
    post "sign_in", to: "users/sessions#create", as: "user_session"
    post "resetpassword", to: "users/passwords#create", as: "user_password"

    patch "resetpassword", to: "users/passwords#update"
    patch "changepassword", to: "users/registrations#update"
    put "resetpassword", to: "users/passwords#update"
    put "changepassword", to: "users/registrations#update"

    delete "sign_out", to: "users/sessions#destroy"
  end

  resources :locations, only: %i(index show) do
    get "search_home", on: :collection, to: "static_pages#search"
    resources :reviews, only: %i(create destroy)
    resources :rooms, only: :show
    resources :reservations, only: %i(new create index)
    collection do
      match "search" => "locations#search", via: [:get, :post], as: :search
    end
  end

  resources :location_types, only: %i(show)

  namespace :admin do
    resources(:users){get "search", on: :collection}
    resources(:location_types){get "search", on: :collection}
    resources(:services, except: :destroy){get "search", on: :collection}
    resources(:bed_details, except: :destroy){get "search", on: :collection}
    resources(:locations, only: %i(index show update)){get "search", on: :collection}

    root "static_pages#home"
  end

  namespace :manager do
    root "static_pages#home"
    resources :locations, except: :index do
      get "search", on: :collection
      resources :reviews, only: :index
      resources(:rooms, except: :destroy){get "search", on: :collection}
      resources(:reservations, only: %i(index update)) do
        get "search", on: :collection
        resources(:reservation_details, only: :index){get "search", on: :collection}
      end
      post "reservations", on: :member, to: "reservations#get_data"
    end
  end
end
