Rails.application.routes.draw do
  jsonapi_resources :users, only: %i[create]

  get 'profile', to: 'users#profile'

  scope 'auth' do
    post 'login', to: 'auth#login'
    post 'refresh_token', to: 'auth#refresh_token'
    post 'logout', to: 'auth#logout'
  end
end
