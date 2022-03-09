Rails.application.routes.draw do
  root 'hello#hello'

  jsonapi_resources :users, only: %i[create show]

  scope 'auth' do
    post 'login', to: 'auth#login'
    post 'logout', to: 'auth#logout'
  end
end
