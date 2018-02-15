Rails.application.routes.draw do
  root 'golfers#index'

  resources :sessions do
    collection do
      delete :sign_out
    end
  end
  resources :golfers
  resources :rounds, only: :index
  namespace :admin do
    resources :golfers
    resources :rounds do
      collection do
        get :recent_updates
      end
    end
  end
end
