Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:create]
    resources :user_auth, only: [:create, :update]

    resources :games, only: [:create] do
      resources :start, only: [:create], controller: 'games/start'
      resources :players, only: [:create], controller: 'games/players'
      resources :roll, only: [:create], controller: 'games/roll'
      resources :purchase, only: [:create], controller: 'games/purchase'
    end
  end
end
