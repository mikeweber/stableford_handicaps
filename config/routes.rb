Rails.application.routes.draw do
  root 'rounds#index'

  resources :golfers
  resources :rounds
end
