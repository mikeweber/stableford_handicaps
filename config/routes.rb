Rails.application.routes.draw do
  root 'admin/rounds#index'

  resources :sessions
  namespace :admin do
    resources :golfers
    resources :rounds do
      collection do
        get :recent_updates
      end
    end
  end
end
