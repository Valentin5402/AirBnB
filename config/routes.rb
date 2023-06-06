Rails.application.routes.draw do
  devise_for :users
  root to: "flats#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :flats do
    resources :bookings, only: [:new, :create]
    resources :reviews, only: [:index, :create]
  end

  resources :bookings, only: [:index, :show, :destroy] do
    member do
      patch 'accept'
      patch 'refuse'
    end
    resources :reviews, only: [:new, :create]
  end
end
