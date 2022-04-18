Rails.application.routes.draw do
  get 'profile', to: 'users#profile'

  resources :users, only: %i[create] do
    collection do
      post 'login', to: 'auth#login'
      post 'refresh_token', to: 'auth#refresh_token'
      post 'logout', to: 'auth#logout'
    end
  end

  resources :tracks, only: %i[index show]
end
