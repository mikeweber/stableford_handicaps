Rails.application.routes.draw do
  root 'rounds#index'

  resources :golfers
  resources :rounds do
    collection do
      get :recent_updates
    end
  end
end
