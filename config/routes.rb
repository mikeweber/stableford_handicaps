Rails.application.routes.draw do
  root 'golfers#index'

  resources :sessions
  resources :golfers
  namespace :admin do
    resources :golfers
    resources :rounds do
      collection do
        get :recent_updates
      end
    end
  end
end
