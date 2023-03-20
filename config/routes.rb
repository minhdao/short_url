Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create]
  post '/auth/login', to: 'authentication#login'
  post '/encode', to: 'links#encode'
  get '/decode', to: 'links#decode'
end
