Rails.application.routes.draw do
  get 'profile', to: 'users#profile'

  resources :users, only: %i[create]
  # post 'users', to: 'users#create'

  scope 'auth' do
    post 'login', to: 'auth#login'
    post 'refresh_token', to: 'auth#refresh_token'
    post 'logout', to: 'auth#logout'
  end
end
